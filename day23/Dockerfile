#---------------- BILD SATGE ---------------
FROM python:3.11-slim AS builder

# install system dependencies needed for building python packages
RUN apt-get update && apt-get install -y --no-install-recommends gcc build-essential && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY requirements.txt .

RUN pip install --user --no-cache-dir -r requirements.txt

#------------------- RUN TIME STAGE ------------------------
FROM python:3.11-slim

# create nonrot user
RUN useradd --create-home appuser
USER appuser 
WORKDIR /home/appuser

# copy only installed packages from builder
COPY --from=builder /root/.local /home/appuser/.local

# Coppy application code 
COPY --chown=appuser:appuser app.py .

# make sure python finds the package
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 5000

CMD ["python3", "app.py"]
