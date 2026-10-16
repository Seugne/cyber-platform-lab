from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        message="CloudGuard application is running",
        service="cloudguard-app",
    )


@app.get("/health")
def health():
    return jsonify(
        status="healthy",
        service="cloudguard-app",
    )
