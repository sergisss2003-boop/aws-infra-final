from fastapi import FastAPI, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlalchemy import text
from pydantic import BaseModel
from typing import Optional
import os

import models
import database

# Crear tablas
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(title="AWS Infra Final API", version="1.0.0")

# Schemas
class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None

class ItemResponse(BaseModel):
    id: int
    name: str
    description: Optional[str] = None

    class Config:
        from_attributes = True

# Endpoints
@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Service is running"}

@app.get("/status")
def status():
    return {
        "status": "ok",
        "service": "AWS Infra Final API",
        "version": "1.0.0"
    }

@app.get("/api/test")
def api_test(db: Session = Depends(database.get_db)):
    try:
        db.execute(text("SELECT 1"))
        db_status = "connected"
    except Exception:
        db_status = "disconnected"
    return {"api": "ok", "database": db_status}

@app.post("/items", response_model=ItemResponse)
def create_item(item: ItemCreate, db: Session = Depends(database.get_db)):
    db_item = models.Item(name=item.name, description=item.description)
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@app.get("/items")
def get_items(db: Session = Depends(database.get_db)):
    items = db.query(models.Item).all()
    return items