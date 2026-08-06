# 🐳 Task Manager — Dockerized 3-Tier Application

> **Portfolio Piece #1** — Month 1 Capstone of my 90-day DevOps transformation journey  
> A production-ready, fully containerized task management REST API

---

## 🏗️ Architecture

```
                    ┌─────────────────────────────────┐
                    │           Host Machine           │
                    │                                  │
                    │    ┌──────────────────────┐      │
                    │    │     backend network   │      │
                    │    │                       │      │
  HTTP :5000 ──────────▶│  ┌─────────────────┐ │      │
                    │    │  │   Flask (web)   │ │      │
                    │    │  │  Python 3.11    │ │      │
                    │    │  │  non-root user  │ │      │
                    │    │  └────┬───────┬────┘ │      │
                    │    │       │       │       │      │
                    │    │  ┌────▼──┐ ┌──▼────┐ │      │
                    │    │  │Redis │ │Postgres│ │      │
                    │    │  │cache │ │database│ │      │
                    │    │  │vol ✅│ │ vol ✅ │ │      │
                    │    │  └──────┘ └────────┘ │      │
                    │    └──────────────────────┘      │
                    └─────────────────────────────────┘
```

| Service | Image | Role | Port |
|---------|-------|------|------|
| **web** | `python:3.11-slim` (multi-stage) | REST API | 5000 |
| **redis** | `redis:7-alpine` | Page view cache | internal |
| **db** | `postgres:16-alpine` | Persistent task storage | internal |

---

## ✨ Features

- ✅ **Multi-stage Dockerfile** — build image 1GB → runtime image ~57MB
- ✅ **Non-root user** — runs as `appuser`, not root (production security)
- ✅ **Healthchecks** on all 3 services — auto-restart on failure
- ✅ **Persistent volumes** — Redis + PostgreSQL data survives restarts
- ✅ **Custom bridge network** — database isolated, not exposed to host
- ✅ **Environment variables** — zero hardcoded secrets
- ✅ **depends_on with service_healthy** — Flask waits for DB + Redis to be truly ready
- ✅ **`.dockerignore`** — clean build context, no secrets in image
- ✅ **REST API** — full CRUD for tasks

---

## 🚀 Quick Start

### Prerequisites

```bash
docker --version    # Docker 24+
docker compose version  # Compose v2+
```

### Run in 3 commands

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/taskmanager-docker.git
cd taskmanager-docker

# 2. Create your .env file (never commit this)
cp .env.example .env

# 3. Start everything
docker compose up -d --build
```

The API is live at **http://localhost:5000**

---

## 📡 API Endpoints

### `GET /`
Welcome message with live Redis hit counter

```bash
curl http://localhost:5000
```
```json
{
  "message": "Hello from Flask!",
  "hostname": "a3f2b1c4d5e6",
  "hits": 42
}
```

---

### `GET /health`
Health check — returns `200 OK` only if Redis + PostgreSQL are both reachable

```bash
curl http://localhost:5000/health
```
```json
{
  "cache": true,
  "database": true
}
```

---

### `GET /tasks`
List all tasks (most recent first, limit 100)

```bash
curl http://localhost:5000/tasks
```
```json
[
  {
    "id": 1,
    "title": "Learn Docker multi-stage builds",
    "created_at": "2026-07-30T14:59:00.000000"
  }
]
```

---

### `POST /tasks`
Create a new task

```bash
curl -X POST http://localhost:5000/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Deploy to AWS ECS"}'
```
```json
{
  "id": 2,
  "title": "Deploy to AWS ECS"
}
```

---

## 🐳 Docker Commands

```bash
# See all running containers + health status
docker compose ps

# Live logs from all services
docker compose logs -f

# Logs from Flask app only
docker compose logs -f web

# Execute shell inside web container
docker exec -it <container_id> bash

# Stop and remove containers (volumes preserved)
docker compose down

# Stop and remove everything including volumes
docker compose down -v

# Rebuild after code changes
docker compose up -d --build web
```

---

## 📁 Project Structure

```
taskmanager-docker/
│
├── app.py                 # Flask application
├── requirements.txt       # Python dependencies
├── Dockerfile             # Multi-stage production Dockerfile
├── docker-compose.yml     # Orchestrates all 3 services
├── .env.example           # Template for environment variables
├── .env                   # Your secrets (git-ignored ✅)
├── .dockerignore          # Excludes secrets from build context
├── .gitignore             # Excludes .env from commits
└── README.md              # This file
```

---

## 🔒 Security Practices Applied

| Practice | Implementation |
|----------|---------------|
| Non-root container user | `useradd -r appuser` + `USER appuser` |
| No hardcoded secrets | All credentials via `.env` |
| `.env` git-ignored | `.gitignore` + `.dockerignore` |
| Minimal runtime image | Multi-stage build — no gcc in production |
| Database not exposed | PostgreSQL + Redis on internal network only |
| Healthchecks | All services monitored, auto-restart on failure |

---

## 📊 Image Size Comparison

| Stage | Size | Notes |
|-------|------|-------|
| `python:3.11` (default) | ~1 GB | Full Python install |
| Builder stage | ~214 MB | With gcc + build tools |
| **Final runtime image** | **~57 MB** | **94% smaller** |

---

## 🛠️ Tech Stack

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python_3.11-3776AB?style=flat&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=flat&logo=flask&logoColor=white)
![Redis](https://img.shields.io/badge/Redis_7-DC382D?style=flat&logo=redis&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL_16-316192?style=flat&logo=postgresql&logoColor=white)

---

## 📚 What I Learned Building This

| Concept | Applied in |
|---------|-----------|
| Multi-stage builds | Dockerfile (builder → runtime) |
| Docker Compose orchestration | docker-compose.yml |
| Service dependency management | `depends_on` + `condition: service_healthy` |
| Container security | Non-root user, no secrets in image |
| Persistent data | Named volumes for Redis + PostgreSQL |
| Network isolation | Custom bridge — DB not exposed to host |
| Healthchecks | `/health` endpoint + Docker HEALTHCHECK |
| Environment variables | `.env` + `docker-compose.yml` |

---

## 🗺️ Part of 90-Day DevOps Journey

This is **Portfolio Piece #1** of 8 projects I am building over 90 days to become a Gulf-remote-ready DevOps engineer.

| Month | Focus | Portfolio pieces |
|-------|-------|-----------------|
| **Month 1 ✅** | Linux · Docker · Python · Bash | Piece #1 (this project) |
| Month 2 | AWS · Terraform · CI/CD | Pieces #2–5 |
| Month 3 | Ansible · Kubernetes · Capstone | Pieces #6–8 |

Follow my journey on LinkedIn → [linkedin.com/in/yourusername](https://linkedin.com/in/yourusername)

---

## 📄 License

MIT License — free to use, modify, and distribute.

---

*Built with 🐳 Docker · Part of #90DaysOfDevOps*
