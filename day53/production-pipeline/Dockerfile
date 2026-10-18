FROM python:3.11-slim

RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser
WORKDIR /home/appuser

COPY --chown=appuser:appgroup requirements.txt .
RUN pip install --user --no-cache-dir -r requirements53.txt

COPY --chown=appuser:appgroup app.py .
ENV PATH=/home/appuser/.local/bin:$PATH

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

CMD ["python3", "app53.py"]

