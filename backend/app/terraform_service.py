import subprocess
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[2]

TERRAFORM_ENVIRONMENTS_DIR = PROJECT_ROOT / "environments"


ALLOWED_ENVIRONMENTS = {
    "dev",
    "prod"
}


def get_terraform_directory(environment: str) -> Path:
    if environment not in ALLOWED_ENVIRONMENTS:
        raise ValueError(
            f"Unsupported Terraform environment: {environment}"
        )

    terraform_dir = TERRAFORM_ENVIRONMENTS_DIR / environment

    if not terraform_dir.exists():
        raise FileNotFoundError(
            f"Terraform environment directory not found: {terraform_dir}"
        )

    return terraform_dir


def run_terraform_command(
    environment: str,
    command: list[str]
):
    terraform_dir = get_terraform_directory(environment)

    result = subprocess.run(
        ["terraform"] + command,
        cwd=str(terraform_dir),
        capture_output=True,
        text=True
    )

    return {
        "success": result.returncode == 0,
        "return_code": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr
    }


def run_terraform_init(environment: str):
    return run_terraform_command(
        environment,
        ["init"]
    )


def run_terraform_plan(environment: str):
    return run_terraform_command(
        environment,
        ["plan"]
    )