FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .

# create a non root user
RUN useradd -m appuser
USER appuser

# Healthcheck (optional)
HEALTHCHECK --interval=10s --timeout=3s --start-period=15s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/')" || exit 1

# Start the app
CMD ["python3", "app.py"]
