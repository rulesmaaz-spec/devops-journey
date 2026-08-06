import time 
import os 
import flask
import redis
import socket
import psycopg2
from flask import Flask, request, jsonify

app = Flask(__name__)

# -------------------------------------------------------------------
# Configuration from environment
# -------------------------------------------------------------------
REDIS_HOST = os.environ.get('REDIS_HOST', 'redis')
DB_HOST = os.environ.get('DB_HOST', 'db')
DB_NAME = os.environ.get('DB_NAME', 'tasks')
DB_USER = os.environ.get('DB_USER', 'postgres')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'postgres')

# -------------------------------------------------------------------
# Redis connection (cache)
# -------------------------------------------------------------------
cache = None
for attempt in range(5):
    try:
        cache = redis.Redis(host=REDIS_HOST, port=6379, db=0, socket_connect_timeout=2)
        cache.ping()
        break
    except redis.ConnectionError:
        time.sleep(2)


# -------------------------------------------------------------------
# PostgreSQL connection (persistent storage)
# -------------------------------------------------------------------
conn = None
for attempt in range(10):
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        break
    except psycopg2.OperationalError:
        time.sleep(2)

# Create table if not exists
if conn:
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS tasks (
            id SERIAL PRIMARY KEY,
            title VARCHAR(200) NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        );
    """)
    conn.commit()
    cur.close()

# -------------------------------------------------------------------
# Routes
# -------------------------------------------------------------------
@app.route('/')
def index():
    hits = cache.incr('hits') if cache else 0
    hostname = socket.gethostname()
    return jsonify({
        'message': 'Hello from Flask!',
        'hostname': hostname,
        'hits': hits
    })

@app.route('/health')
def health():
    # Check all dependencies
    cache_ok = False
    if cache:
        try:
            cache.ping()
            cache_ok = True
        except Exception:
            pass

    db_ok = False
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("SELECT 1")
            cur.close()
            db_ok = True
        except Exception:
            pass

    status = 200 if (cache_ok and db_ok) else 503
    return jsonify({
        'cache': cache_ok,
        'database': db_ok
    }), status

@app.route('/tasks', methods=['GET', 'POST'])
def tasks():
    if not conn:
        return jsonify({'error': 'database not available'}), 503

    if request.method == 'POST':
        data = request.get_json(force=True)
        title = data.get('title')
        if not title:
            return jsonify({'error': 'title is required'}), 400
        cur = conn.cursor()
        cur.execute("INSERT INTO tasks (title) VALUES (%s) RETURNING id", (title,))
        task_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        return jsonify({'id': task_id, 'title': title}), 201

    # GET
    cur = conn.cursor()
    cur.execute("SELECT id, title, created_at FROM tasks ORDER BY created_at DESC LIMIT 100")
    rows = cur.fetchall()
    cur.close()
    tasks_list = [{'id': r[0], 'title': r[1], 'created_at': r[2].isoformat()} for r in rows]
    return jsonify(tasks_list)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    