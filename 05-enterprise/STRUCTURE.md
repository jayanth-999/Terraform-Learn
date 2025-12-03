# Enterprise Terraform Structure

In large organizations, you don't just dump everything in one folder. You split things up by **Environment** and **Component**.

## Recommended Directory Layout

```text
infrastructure/
├── modules/                 # Reusable code (like our file_writer)
│   ├── networking/
│   ├── database/
│   └── app-cluster/
├── environments/            # Live infrastructure
│   ├── dev/
│   │   ├── main.tf          # Calls modules
│   │   ├── variables.tf
│   │   └── backend.tf       # State for DEV
│   ├── prod/
│   │   ├── main.tf          # Calls modules
│   │   ├── variables.tf
│   │   └── backend.tf       # State for PROD
│   └── shared/              # Global resources (IAM, ECR)
└── scripts/                 # Helper scripts
```

## CI/CD Pipeline Checks
Before any code is merged, your CI/CD (Jenkins, GitHub Actions) should run:

1.  **`terraform fmt -check`**: Ensures code follows the standard style.
2.  **`terraform validate`**: Checks for syntax errors and valid arguments.
3.  **`terraform plan`**: Shows what will change.
