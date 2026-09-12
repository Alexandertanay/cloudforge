import subprocess
from pathlib import Path


# CloudForge backend:
# C:\Users\ASUS\CloudForge\terraform\backend
#
# Terraform dev environment:
# C:\Users\ASUS\CloudForge\terraform\environments\dev

TERRAFORM_DIR = (
    Path(__file__).resolve().parent.parent / "environments" / "dev"
)


def run_terraform_plan():
    """
    Runs Terraform plan for the CloudForge dev environment.
    Does not create or modify infrastructure.
    """

    result = subprocess.run(
        ["terraform", "plan"],
        cwd=TERRAFORM_DIR,
        capture_output=True,
        text=True
    )

    return {
        "success": result.returncode == 0,
        "return_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }