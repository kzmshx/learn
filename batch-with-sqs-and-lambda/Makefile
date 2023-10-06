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
REGION    = ap-northest-1

# ------------------------------
# Terraform
# ------------------------------
.PHONE: cd-terraform
cd-terraform:
	@cd terraform

.PHONY: setup-terraform
setup-terraform:
	@tfenv install ${TERRAFORM_VERSION}
	@tfenv use ${TERRAFORM_VERSION}

.PHONY: init
init: cd-terraform setup-terraform
	@terraform init \
		-backend-config="bucket=${TFSTATE_BUCKET}" \
		-backend-config="key=${TFSTATE_KEY}" \
		-backend-config="region=${REGION}"

.PHONY: plan
plan: cd-terraform setup-terraform
	@terraform plan \
		-var "region=${REGION}"

.PHONY: apply
apply: cd-terraform setup-terraform
	@terraform apply \
		-var "region=${REGION}"

.PHONY: destroy
destroy: cd-terraform setup-terraform
	@terraform destroy \
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
