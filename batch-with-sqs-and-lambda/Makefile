ENV_PATH := .env
ifneq ($(wildcard $(ENV_PATH)),)
	include $(ENV_PATH)
endif

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

SHELL             = /bin/bash
TERRAFORM_VERSION = 1.6.0
TFSTATE_BUCKET    = batch-with-sqs-and-lambda-tfstate
TFSTATE_KEY       = batch-with-sqs-and-lambda.tfstate
REGION            = ap-northeast-1

# ------------------------------
# Terraform
# ------------------------------
.PHONY: setup-terraform
setup-terraform:
	@tfenv install ${TERRAFORM_VERSION}
	@tfenv use ${TERRAFORM_VERSION}

.PHONY: init
init: setup-terraform
	@cd terraform && terraform init \
		-backend-config="bucket=${TFSTATE_BUCKET}" \
		-backend-config="key=${TFSTATE_KEY}" \
		-backend-config="region=${REGION}"

.PHONY: plan
plan: setup-terraform
	@cd terraform && terraform plan \
		-var "region=${REGION}"

.PHONY: apply
apply: setup-terraform
	@cd terraform && terraform apply \
		-var "region=${REGION}" \
		-auto-approve

.PHONY: destroy
destroy: setup-terraform
	@cd terraform && terraform destroy \
		-var "region=${REGION}"

# ------------------------------
# Shell scripts
# ------------------------------
.PHONY: upload
upload:
	@bash scripts/upload.sh

.PHONY: download
download:
	@bash scripts/download.sh
