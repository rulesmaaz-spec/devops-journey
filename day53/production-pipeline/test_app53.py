from app53 import app


def test_index():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert response.json["app"] == "pipeline-demo"


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json["status"] == "healthy"
