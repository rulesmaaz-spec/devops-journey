
import time
from flask import Flask
import redis
import os

app = Flask(__name__)

# connect to redis using the service name (composes internal DNS)
# retry loop because redis ight not be ready imideatly
for attempt in range(10):
    try:
        cache = redis.Redis(host='redis', port=6379, db=0)
        cache.ping()
        break
    except redis.ConnectionError:
        print(f"Waiting for Redis... attempt {attempt+1}")
        time.sleep(2)

@app.route('/')
def hello():
    count = cache.incr('hits')
    return f'Hello from Flask! This page has been viewed {count} times.\n'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)