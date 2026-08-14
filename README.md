# terraform-cicd-portfolio

A modular Terraform project (VPC + EC2 compute) with a GitHub Actions
CI/CD pipeline that enforces plan-before-apply through pull request
review.

## Architecture

```
├── main.tf              # root module - wires vpc + compute together
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/              # VPC, subnets, IGW, NAT gateway, security group
│   └── compute/          # EC2 instance, provisioned via user_data
└── .github/workflows/
    └── terraform.yml     # CI/CD pipeline
```

## Why modules?

Instead of one large `.tf` file, resources are split by concern
(networking vs. compute). Each module is self-contained with its own
`variables.tf` / `outputs.tf`, and the root `main.tf` wires them
together by passing outputs from one module into another (e.g. the
VPC's subnet ID feeds into the compute module). This makes each piece
independently reusable and easier to reason about in review.

## State management

State is stored remotely in an S3 bucket (`backend "s3"` block in
`main.tf`), with a DynamoDB table providing **state locking** - this
prevents two people (or a person and a CI run) from applying changes
at the same time and corrupting the state file. This is standard
practice for any team environment; local state files don't scale past
a single person.

## CI/CD pipeline

The pipeline enforces a review-before-apply workflow:

1. **Pull request opened** (changing any `.tf` file) → pipeline runs
   `fmt`, `validate`, and `plan`, then **posts the plan output as a PR
   comment** so reviewers can see the exact infrastructure diff before
   approving - the same principle as code review, applied to
   infrastructure.
2. **PR approved and merged to `main`** → pipeline runs `apply`
   automatically. Nothing is ever applied directly from a PR branch or
   a developer's machine.
3. **Credentials** are pulled from GitHub Actions secrets
   (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`) at runtime - never
   committed to the repo.

In a production setup, the apply step would also sit behind a GitHub
Environment with a required manual approver, adding a second human
gate specifically for production changes.

## Usage

```bash
terraform init      # downloads providers, configures the S3 backend
terraform plan       # preview changes - safe, makes no changes
terraform apply       # apply changes (normally done via CI, not locally)
terraform destroy       # tear down all resources
```

## Notes

- Before running this for real: replace `REPLACE-WITH-YOUR-STATE-BUCKET`
  in `main.tf` with an actual S3 bucket name, and create the
  `terraform-locks` DynamoDB table (partition key: `LockID`, type String).
- The security group currently allows SSH/HTTP from `0.0.0.0/0` for
  demo simplicity - in a real deployment this should be restricted to
  known IP ranges.
