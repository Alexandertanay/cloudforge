from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, Field
from uuid import uuid4
from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Deployment
from app.policy_engine import validate_deployment
from app.terraform_service import run_terraform_plan


router = APIRouter(
    prefix="/api/v1/deployments",
    tags=["Deployments"]
)


class DeploymentCreate(BaseModel):
    project_id: str
    environment: str = Field(default="dev")
    region: str = Field(default="ap-south-1")
    instance_type: str = Field(default="t3.micro")


def deployment_response(deployment):
    return {
        "id": deployment.id,
        "project_id": deployment.project_id,
        "environment": deployment.environment,
        "region": deployment.region,
        "instance_type": deployment.instance_type,
        "status": deployment.status,
        "policy_status": deployment.policy_status,
        "created_at": deployment.created_at
    }


@router.post("/")
def create_deployment(
    deployment: DeploymentCreate,
    db: Session = Depends(get_db)
):
    # Validate deployment against CloudForge policies
    policy_result = validate_deployment(
        environment=deployment.environment,
        region=deployment.region,
        instance_type=deployment.instance_type
    )

    # Reject deployment if policy fails
    if not policy_result["allowed"]:
        raise HTTPException(
            status_code=400,
            detail={
                "message": "Deployment rejected by CloudForge policy engine",
                "errors": policy_result["errors"]
            }
        )

    # Generate deployment ID
    deployment_id = str(uuid4())

    # Create database record
    new_deployment = Deployment(
        id=deployment_id,
        project_id=deployment.project_id,
        environment=deployment.environment,
        region=deployment.region,
        instance_type=deployment.instance_type,
        status="pending",
        policy_status="approved",
        created_at=datetime.now(timezone.utc)
    )

    # Save deployment
    db.add(new_deployment)
    db.commit()
    db.refresh(new_deployment)

    return deployment_response(new_deployment)


@router.get("/")
def list_deployments(
    db: Session = Depends(get_db)
):
    deployments = db.query(Deployment).all()

    return {
        "count": len(deployments),
        "deployments": [
            deployment_response(deployment)
            for deployment in deployments
        ]
    }


@router.get("/{deployment_id}")
def get_deployment(
    deployment_id: str,
    db: Session = Depends(get_db)
):
    deployment = db.query(Deployment).filter(
        Deployment.id == deployment_id
    ).first()

    if not deployment:
        raise HTTPException(
            status_code=404,
            detail="Deployment not found"
        )

    return deployment_response(deployment)


@router.post("/{deployment_id}/plan")
def plan_deployment(
    deployment_id: str,
    db: Session = Depends(get_db)
):
    deployment = db.query(Deployment).filter(
        Deployment.id == deployment_id
    ).first()

    if not deployment:
        raise HTTPException(
            status_code=404,
            detail="Deployment not found"
        )

    # Update status before Terraform execution
    deployment.status = "planning"
    db.commit()

    try:
        result = run_terraform_plan()

        if result["success"]:
            deployment.status = "planned"
        else:
            deployment.status = "plan_failed"

        db.commit()
        db.refresh(deployment)

        return {
            "deployment_id": deployment_id,
            "status": deployment.status,
            "terraform": result
        }

    except Exception as error:
        deployment.status = "plan_failed"
        db.commit()

        raise HTTPException(
            status_code=500,
            detail=f"Terraform plan failed: {str(error)}"
        )
@router.post("/{deployment_id}/cancel")
def cancel_deployment(
    deployment_id: str,
    db: Session = Depends(get_db)
):
    deployment = db.query(Deployment).filter(
        Deployment.id == deployment_id
    ).first()

    if not deployment:
        raise HTTPException(
            status_code=404,
            detail="Deployment not found"
        )

    if deployment.status in ["deployed", "applying"]:
        raise HTTPException(
            status_code=400,
            detail=f"Deployment cannot be cancelled while status is '{deployment.status}'"
        )

    deployment.status = "cancelled"

    db.commit()
    db.refresh(deployment)

    return deployment_response(deployment)
    @router.post("/{deployment_id}/status")
def update_deployment_status(
    deployment_id: str,
    status: str,
    db: Session = Depends(get_db)
):
    deployment = db.query(Deployment).filter(
        Deployment.id == deployment_id
    ).first()

    if not deployment:
        raise HTTPException(
            status_code=404,
            detail="Deployment not found"
        )

    allowed_statuses = {
        "pending",
        "planning",
        "planned",
        "applying",
        "deployed",
        "plan_failed",
        "apply_failed",
        "cancelled"
    }

    if status not in allowed_statuses:
        raise HTTPException(
            status_code=400,
            detail={
                "message": "Invalid deployment status",
                "allowed_statuses": sorted(allowed_statuses)
            }
        )

    deployment.status = status

    db.commit()
    db.refresh(deployment)

    return deployment_response(deployment)
