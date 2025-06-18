# Serverless URL Shortener

A fully automated, serverless URL shortener built with **AWS Lambda**, **API Gateway**, **DynamoDB**, and **Terraform** — with full CI/CD using **GitHub Actions** and code quality enforcement via **SonarQube**.

---

##  Features

-  Shorten long URLs into compact 6-character codes
-  Redirect users using GET /{code}
-  100% Serverless (no EC2 needed for the application)
-  Automated CI/CD: lint, test, SonarQube scan, Lambda packaging, and Terraform deployment
-  Quality gate enforcement via SonarQube (self-hosted)
-  Real-time CloudWatch alarm for 5XX API Gateway errors + email alert

---

##  Prerequisites

Before you begin, ensure you have the following infrastructure:

###  AWS Setup

| Resource         | Purpose                                  |
|------------------|------------------------------------------|
| S3 Bucket        | Store Terraform remote state             |
| DynamoDB Table   | Terraform state locking (`terraform-locks`) |
| IAM User         | Programmatic access for GitHub Actions   |

Update these in `providers.tf` and `terraform.tfvars` accordingly.

###  SonarQube Setup

1. Launch a **t3.medium EC2 instance**
2. Allow **ports 22 and 9000**
3. Access: `http://<EC2_PUBLIC_IP>:9000`
4. Create a project and generate a **token**
5. Add this token to GitHub as `SONAR_TOKEN`

---

##  How to Deploy

1. Fork or clone the repository

2. Set the following GitHub **Secrets**:

| Secret Name             | Description                          |
|--------------------------|--------------------------------------|
| `AWS_ACCESS_KEY_ID`      | IAM user's access key                |
| `AWS_SECRET_ACCESS_KEY`  | IAM user's secret key                |
| `SONAR_TOKEN`            | Token generated in SonarQube         |
| `EMAIL_USERNAME`         | Gmail or SMTP username               |
| `EMAIL_PASSWORD`         | Password or app-specific password    |
| `SLACK_WEBHOOK`          | (Optional) Slack notification webhook|

3. Configure `terraform.tfvars`:

```hcl
table_name                   = "url-shortener-table"
lambda_runtime               = "python3.12"
create_lambda_function_name = "createLink"
redirect_lambda_function_name = "redirect"
api_gateway_name             = "url-shortener-api"
lambda_exec_role_name        = "url_shortener_lambda_exec"
aws_region                   = "us-east-1"
alert_email                  = "your@email.com"
```

4. Push to `main` branch to trigger the pipeline:

```bash
git add .
git commit -m "Initial setup"
git push origin main
```

---

##  API Usage

### POST `/shorten`

**Request:**
```bash
curl -X POST https://<api_url>/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com"}'
```

**Response:**
```json
{
  "short_url": "https://<api_url>/<code>"
}
```

---

### GET `/{code}`

Redirects to the original long URL if the code exists.

```bash
curl -L https://<api_url>/<code>
```

---

##  Testing

Local testing is powered by `pytest` and `moto`.

Install requirements:

```bash
pip install -r requirements.txt
pytest
```

---

##  Project Structure

```
.
├── modules/
│   ├── lambda/              # Lambda ZIP deployment
│   ├── iam/                 # IAM roles/policies
│   ├── apigateway/          # HTTP API config
│   ├── dynamodb/            # Table for URL codes
│   └── cloudwatch_alert/    # Alerts + SNS setup
├── create_link.py           # Lambda handler for short URL creation
├── redirect.py              # Lambda handler for redirect logic
├── build_lambda_zip.sh      # Docker zip builder
├── Dockerfile               # Docker setup for lambda packaging
├── .github/workflows/       # CI/CD pipelines
└── terraform.tfvars         # Terraform variables
```

---

##  GitHub Actions Workflow

| Stage               | Description                            |
|---------------------|----------------------------------------|
| `lint-and-test`     | Runs `flake8`, `pytest`                |
| `sonarqube-scan`    | SonarQube scan + Quality Gate check    |
| `build-lambda`      | Docker-based zip builder for Lambda    |
| `deploy`            | Terraform Init → Plan → Apply          |
| `integration-test`  | API + error simulation + Slack/email   |

---

##  Monitoring

- **CloudWatch Alarm** triggers if >5 5XX errors occur in 60 seconds
- **SNS Email Alert** is sent to `alert_email` defined in `terraform.tfvars`
- Alarms simulate errors using:  
  `POST /shorten?force_error=true`
---

## 📈 SonarQube Setup

To integrate SonarQube with GitHub Actions, you can deploy SonarQube on an EC2 instance (recommended: Ubuntu 22.04, t3.medium). Open port 9000 for access and port 22 for SSH.
# Launch EC2 & Install SonarQube
```bash
# Step 1: Launch EC2 (manual step via AWS Console)
# AMI: Ubuntu 22.04 LTS
# Instance type: t3.medium
# Open inbound ports: 22 (SSH), 9000 (SonarQube)

# Step 2: SSH into your instance
ssh -i "your-key.pem" ubuntu@<EC2_PUBLIC_IP>

# Step 3: Install Java & utilities
sudo apt update
sudo apt install -y openjdk-17-jdk unzip wget

# Step 4: Download and set up SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
unzip sonarqube-10.5.1.90531.zip
sudo mv sonarqube-10.5.1.90531 /opt/sonarqube
sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Step 5: Start SonarQube (run as non-root)
cd /opt/sonarqube/bin/linux-x86-64/
sudo -u sonarqube ./sonar.sh start
```
Once SonarQube is running, go to:
 http://<EC2_PUBLIC_IP>:9000
(Default login: admin / admin → reset password on first login)
Then create a project → generate token → save token in GitHub Secrets as SONAR_TOKEN.
- Access: `http://<EC2_PUBLIC_IP>:9000`
- Create a project: `serverless`
- Copy token to GitHub Secrets as `SONAR_TOKEN`
- Configured in `.github/workflows/cicd.yml`

---

##  Lambda Environment Variables

| Variable    | Description                        |
|-------------|------------------------------------|
| `TABLE_NAME`| DynamoDB table storing URL mappings|

---

##  License

This project is licensed under the [MIT License](LICENSE).

---

##  Author

**Pavan Vinjamuri**  
Cloud | DevOps | Terraform | AWS | CI/CD | SAP BASIS  
 pavanvinjamuri017@gmail.com

---
