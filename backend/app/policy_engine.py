ALLOWED_INSTANCE_TYPES = {
    "t3.micro",
    "t3.small",
    "t3.medium"
}

ALLOWED_ENVIRONMENTS = {
    "dev",
    "prod"
}


def validate_deployment(
    environment: str,
    region: str,
    instance_type: str
):
    errors = []

    # Environment policy
    if environment not in ALLOWED_ENVIRONMENTS:
        errors.append(
            f"Environment '{environment}' is not allowed."
        )

    # Instance type policy
    if instance_type not in ALLOWED_INSTANCE_TYPES:
        errors.append(
            f"Instance type '{instance_type}' is not allowed by CloudForge cost policy."
        )

    # Region policy
    if region != "ap-south-1":
        errors.append(
            f"Region '{region}' is not currently supported."
        )

    return {
        "allowed": len(errors) == 0,
        "errors": errors
    }