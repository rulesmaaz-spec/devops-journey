"""Simple app for pipeline demo."""
import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify({
        "app": "pipeline-demo",
        "version": os.getenv("APP_VERSION", "dev"),
        "status": "ok"
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
