from app.policy_engine import validate_deployment


def test_valid_deployment_is_allowed():
    result = validate_deployment(
        environment="dev",
        region="ap-south-1",
        instance_type="t3.micro"
    )

    assert result["allowed"] is True
    assert result["errors"] == []


def test_large_instance_is_rejected():
    result = validate_deployment(
        environment="dev",
        region="ap-south-1",
        instance_type="t3.2xlarge"
    )

    assert result["allowed"] is False
    assert len(result["errors"]) > 0


def test_invalid_environment_is_rejected():
    result = validate_deployment(
        environment="staging",
        region="ap-south-1",
        instance_type="t3.micro"
    )

    assert result["allowed"] is False


def test_invalid_region_is_rejected():
    result = validate_deployment(
        environment="dev",
        region="us-east-1",
        instance_type="t3.micro"
    )

    assert result["allowed"] is False