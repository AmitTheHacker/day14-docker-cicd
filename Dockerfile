# Use an official, lightweight slim Python runtime base image
FROM python:3.12-slim

# Prevent Python from writing pyc files and keep stdout/stderr unbuffered for live logging
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Create a restricted system user to enforce the principle of least privilege
RUN useradd --system --uid 10001 app
USER app

EXPOSE 5000

CMD ["python", "app.py"]
