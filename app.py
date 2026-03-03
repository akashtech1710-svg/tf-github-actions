from flask import Flask, jsonify, request, render_template
import random
import time
import os
import socket

app = Flask(__name__)

HOSTNAME = socket.gethostname()
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "hostname": HOSTNAME,
        "environment": ENVIRONMENT
    })


@app.route("/api/time")
def get_time():
    return jsonify({
        "time": int(time.time()),
        "hostname": HOSTNAME,
        "environment": ENVIRONMENT
    })


@app.route("/api/random")
def random_numbers():
    numbers = [random.randint(1, 100) for _ in range(5)]
    return jsonify({
        "numbers": numbers,
        "hostname": HOSTNAME,
        "environment": ENVIRONMENT
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)