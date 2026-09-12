from sqlalchemy import Column, String, DateTime
from datetime import datetime, timezone

from app.database import Base


class Project(Base):
    __tablename__ = "projects"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    environment = Column(String, nullable=False)
    region = Column(String, nullable=False)
    created_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc)
    )


class Deployment(Base):
    __tablename__ = "deployments"

    id = Column(String, primary_key=True, index=True)
    project_id = Column(String, nullable=False)
    environment = Column(String, nullable=False)
    region = Column(String, nullable=False)
    instance_type = Column(String, nullable=False)
    status = Column(String, nullable=False)
    policy_status = Column(String, nullable=False)
    created_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc)
    )