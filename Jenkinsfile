pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    PYTHON_VERSION = '3.12'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Python & Deps') {
      steps {
        sh '''
          python3 -m venv venv
          . venv/bin/activate
          pip install -r requirements.txt
        '''
      }
    }

    stage('Lint & Unit Test') {
      steps {
        sh '''
          . venv/bin/activate
          flake8 create_link.py redirect.py
          PYTHONPATH=. pytest tests/
        '''
      }
    }

    stage('Build Lambda ZIPs') {
      steps {
        sh '''
          chmod +x build_lambda_zip.sh
          ./build_lambda_zip.sh create_link.py create_link.zip
          ./build_lambda_zip.sh redirect.py redirect.zip
        '''
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds-id']]) {
          sh '''
            terraform init
            terraform plan
            terraform apply -auto-approve
          '''
        }
      }
    }

   stage('Integration Test') {
  steps {
    script {
      def apiUrl = sh(script: "terraform output -raw api_url", returnStdout: true).trim()
      sh """
        curl -X POST "${apiUrl}/shorten" \\
          -H "Content-Type: application/json" \\
          -d '{\"url\": \"https://example.com\"}'
      """
    }
  }
}

  }
}
