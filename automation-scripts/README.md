# Aml Infrastructure Setup Instructions

## Configuration

Define the necessary configurations in the `aml.conf` file:


```bash
AWS_ACCESS_KEY_ID="$access_key"
AWS_SECRET_ACCESS_KEY="$secret_key"
AWS_DEFAULT_REGION="$region"
KUBE_CONFIG_PATH="$HOME/.kube"
AWS_TERRAFORM_BACKEND_BUCKET_NAME="$bucket_name"
AWS_TERRAFORM_BACKEND_BUCKET_REGION="$region"

# Add more variables as needed
```
Replace placeholders (`$access_key`, `$secret_key`, `$region`, `$bucket_name`, etc.) with actual values.

You can also customize the values in `terraform/aws/vars/cluster_overrides.tfvars` according to your needs.


## Tool Installation

Ensure the installation of the following tools:

| Tool        | Version      |
|-------------|--------------|
| aws         | >=2.13.8     |
| helm        | >=3.10.2     |
| terraform   | >=1.5.7      |
| terrahelp   | >=0.7.5      |
| terragrunt  | >=0.45.6     |

## Setup Process

1. Navigate to the `automation-scripts/infra-setup` directory: `cd automation-scripts/infra-setup`
2. Run Installation Script: Execute the following command to start the installation process:
    - Before installing please provide executable permission to installation script
    `chmod +x ./aml.sh`
    ```bash
    ./aml.sh install --config ./aml.conf --install_dependencies false
    ```
    - Note: Setting install_dependencies=true will automatically download and install all required dependencies. If preferred, you can manually download the dependencies instead.
3. Monitor Installation Progress: The script will begin installing aml within the AWS cluster. Monitor the progress and follow any on-screen prompts or instructions.

