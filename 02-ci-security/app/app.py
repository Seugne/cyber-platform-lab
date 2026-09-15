from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def index():
    return jsonify(
        message="CloudGuard SecurePipeline application is running",
        service="cloudguard-secure-pipeline",
    )


@app.get("/health")
def health():
    return jsonify(
        status="healthy",
        service="cloudguard-secure-pipeline",
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
