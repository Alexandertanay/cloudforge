from fastapi import FastAPI
from datetime import datetime, timezone

from app.database import engine, Base
from app import models

from app.projects import router as projects_router
from app.deployments import router as deployments_router


# Create database tables
Base.metadata.create_all(bind=engine)


# Create FastAPI application
app = FastAPI(
    title="CloudForge API",
    description="Self-service AWS deployment platform powered by Terraform",
    version="1.0.0",
)


# Register API routers
app.include_router(projects_router)
app.include_router(deployments_router)


@app.get("/")
def root():
    return {
        "service": "CloudForge API",
        "status": "running",
        "version": "1.0.0",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "cloudforge-api"
    }


@app.get("/api/v1/info")
def info():
    return {
        "platform": "CloudForge",
        "purpose": "Self-service AWS infrastructure deployment",
        "infrastructure_engine": "Terraform",
        "container_platform": "Docker",
        "cloud_provider": "AWS",
        "database": "SQLite"
    }


