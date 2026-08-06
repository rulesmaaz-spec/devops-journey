# ============ BUILD STAGE ============
FROM python:3.11-slim AS builder
#RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev && \
#rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# ============ RUNTIME STAGE ============
FROM python:3.11-slim
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 curl && \
    rm -rf /var/lib/apt/lists/*
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser
WORKDIR /home/appuser
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH=/home/appuser/.local/bin:$PATH
COPY --chown=appuser:appgroup app.py .
HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1
EXPOSE 5000
CMD ["python3", "app.py"]