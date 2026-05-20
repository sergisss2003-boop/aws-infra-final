from fastapi.testclient import TestClient
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '../app'))

from main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"

def test_status():
    response = client.get("/status")
    assert response.status_code == 200
    assert response.json()["service"] == "AWS Infra Final API"

def test_api_test():
    response = client.get("/api/test")
    assert response.status_code == 200
    assert response.json()["api"] == "ok"

def test_create_item():
    response = client.post("/items", json={
        "name": "Test Item",
        "description": "Item de prueba"
    })
    assert response.status_code == 200
    assert response.json()["name"] == "Test Item"

def test_get_items():
    response = client.get("/items")
    assert response.status_code == 200
    assert isinstance(response.json(), list)