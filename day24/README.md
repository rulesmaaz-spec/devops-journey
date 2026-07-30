# Flask + Redis Counter

A simple two‑service application defined with Docker Compose.

## Services
- **web**: Python Flask app that counts page views.
- **redis**: Redis database that persists the count.

## How to run
1. docker compose up -d --build
2. curl http://localhost:5000

## Technologies
- Docker Compose
- Flask
- Redis (Alpine)
- Named volumes for data persistence
