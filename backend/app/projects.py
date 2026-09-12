from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, Field
from uuid import uuid4
from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Project


router = APIRouter(
    prefix="/api/v1/projects",
    tags=["Projects"]
)


class ProjectCreate(BaseModel):
    name: str = Field(..., min_length=3, max_length=50)
    environment: str = Field(default="dev")
    region: str = Field(default="ap-south-1")


@router.post("/")
def create_project(
    project: ProjectCreate,
    db: Session = Depends(get_db)
):
    project_id = str(uuid4())

    new_project = Project(
        id=project_id,
        name=project.name,
        environment=project.environment,
        region=project.region,
        created_at=datetime.now(timezone.utc)
    )

    db.add(new_project)
    db.commit()
    db.refresh(new_project)

    return {
        "id": new_project.id,
        "name": new_project.name,
        "environment": new_project.environment,
        "region": new_project.region,
        "created_at": new_project.created_at
    }


@router.get("/")
def list_projects(
    db: Session = Depends(get_db)
):
    projects = db.query(Project).all()

    return {
        "count": len(projects),
        "projects": [
            {
                "id": project.id,
                "name": project.name,
                "environment": project.environment,
                "region": project.region,
                "created_at": project.created_at
            }
            for project in projects
        ]
    }


@router.get("/{project_id}")
def get_project(
    project_id: str,
    db: Session = Depends(get_db)
):
    project = db.query(Project).filter(
        Project.id == project_id
    ).first()

    if not project:
        raise HTTPException(
            status_code=404,
            detail="Project not found"
        )

    return {
        "id": project.id,
        "name": project.name,
        "environment": project.environment,
        "region": project.region,
        "created_at": project.created_at
    }