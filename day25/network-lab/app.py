from flask import Flask
import socket 
import redis
import time 

app = Flask(__name__)

# connect to redis (retry)
cache = None
for _ in range(5):
    try:
        cache = redis.Redis(host = 'redis', port=6379, db=0)
        cache.ping()
        break
    except redis.ConnectionError:
        time.sleep(2)
else:
    raise Exception("Could not connect to Redis")

@app.route('/')
def hello():
    hostname = socket.gethostname()
    count = cache.incr('hits') if cache else 0
    return f"Host: {hostname}, Hits: {count}\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
