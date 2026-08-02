FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .

# create a non root user
RUN useradd -m appuser
USER appuser
CMD ["python3", "app.py"]