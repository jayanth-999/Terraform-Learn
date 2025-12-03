# Enterprise State Management

## The Problem with Local State
So far, `terraform.tfstate` has been sitting in your folder.
- **Team Issue**: If I join your team, I don't have your `terraform.tfstate`. If I run `apply`, I might destroy your resources or create duplicates.
- **Security**: State files contain secrets (passwords, keys) in plain text. Storing them on a laptop is risky.
- **Race Conditions**: If we both run `apply` at the same time, we corrupt the state.

## The Solution: Remote Backends
We store the state in a shared, locked, remote location.
- **AWS**: S3 (Storage) + DynamoDB (Locking)
- **Azure**: Blob Storage (Storage + Locking)
- **GCP**: GCS (Storage + Locking)

## Simulation
Since we might not have cloud credentials handy, we will simulate this by saving the state to a "shared" location outside our project folder.

### Real World Example (AWS)
If you had AWS access, your `backend.tf` would look like this:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-corp-terraform-state"
    key            = "prod/app1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # Prevents concurrent runs
    encrypt        = true
  }
}
```
