import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def home():
    # Return basic application metadata using runtime environment context
    return jsonify(message="Docker CI/CD lab", environment=os.getenv("APP_ENV", "dev"))

@app.get("/health")
def health():
    # Dedicated smoke-test endpoint for downstream lifecycle verification
    return "ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
