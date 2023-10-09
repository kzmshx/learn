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
# Env
# ------------------------------
.PHONY: env
env:
	@cp -n $(ENV_PATH).tpl $(ENV_PATH)

# ------------------------------
# Terraform
# ------------------------------
.PHONY: setup-terraform
setup-terraform:
	@tfenv install ${TERRAFORM_VERSION} >&2
	@tfenv use ${TERRAFORM_VERSION} >&2

.PHONY: init
init: setup-terraform
	@cd terraform && terraform init \
		-backend-config="bucket=${TFSTATE_BUCKET}" \
		-backend-config="key=${TFSTATE_KEY}" \
		-backend-config="region=${REGION}"

.PHONY: init-reconfigure
init-reconfigure: setup-terraform
	@cd terraform && terraform init \
		-reconfigure \
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

.PHONY: output
output: setup-terraform
	@cd terraform && terraform output \
		-json

# ------------------------------
# Shell scripts
# ------------------------------
.PHONY: upload
upload:
	@bash scripts/upload_inputs.sh

.PHONY: download
download:
	@bash scripts/download_outputs.sh
