from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        service="securepipeline",
        status="running",
        message="SecurePipeline application is running",
    )


@app.get("/health")
def health():
    return jsonify(
        service="securepipeline",
        status="healthy",
    )
