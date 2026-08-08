#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tenant_id="${AZURE_TENANT_ID:-}"
subscription_id="${AZURE_SUBSCRIPTION_ID:-}"
deployment_name="${AZURE_DEPLOYMENT_NAME:-creaturely-site-prod-infrastructure}"
github_environment="${GITHUB_ENVIRONMENT:-prod}"
workflow_application_name="${AZURE_WORKFLOW_APPLICATION_NAME:-creaturely-site-prod-workflow}"

if ! command -v az >/dev/null 2>&1; then
  echo 'Azure CLI is required: https://learn.microsoft.com/cli/azure/install-azure-cli' >&2
  exit 1
fi

if [[ -z "$tenant_id" || -z "$subscription_id" ]]; then
  echo 'AZURE_TENANT_ID and AZURE_SUBSCRIPTION_ID are required.' >&2
  exit 1
fi

if ! az account show >/dev/null 2>&1; then
  echo "Azure CLI is not signed in. Run az login --tenant $tenant_id and retry." >&2
  exit 1
fi

az account set --subscription "$subscription_id"

active_tenant_id="$(az account show --query tenantId --output tsv)"
if [[ "$active_tenant_id" != "$tenant_id" ]]; then
  echo "Subscription $subscription_id belongs to tenant $active_tenant_id, not $tenant_id." >&2
  exit 1
fi

deployment_args=(
  --name "$deployment_name"
  --location centralus
  --template-file "$script_dir/bootstrap.bicep"
  --only-show-errors
)

if [[ "${1:-}" == '--what-if' ]]; then
  az deployment sub what-if "${deployment_args[@]}"
  exit 0
fi

if [[ $# -gt 0 ]]; then
  echo "Unknown argument: $1" >&2
  echo 'Usage: ./infra/site/deploy.sh [--what-if]' >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  echo 'GitHub CLI must be signed in before bootstrapping the deployment workflow.' >&2
  exit 1
fi

github_repository="${GITHUB_REPOSITORY:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}"
github_oidc_subject_prefix="$(gh api \
  --header 'X-GitHub-Api-Version: 2026-03-10' \
  "repos/$github_repository/actions/oidc/customization/sub" \
  --jq '.sub_claim_prefix // empty')"

if [[ -z "$github_oidc_subject_prefix" ]]; then
  echo "Unable to resolve the effective GitHub OIDC subject for $github_repository." >&2
  exit 1
fi

echo "Deploying Creaturely site infrastructure to subscription $(az account show --query name -o tsv) ($subscription_id)..."
az deployment sub create "${deployment_args[@]}" --output none

default_hostname="$(az deployment sub show \
  --name "$deployment_name" \
  --query properties.outputs.defaultHostname.value \
  --output tsv)"
resource_group_name="$(az deployment sub show \
  --name "$deployment_name" \
  --query properties.outputs.resourceGroupName.value \
  --output tsv)"
workflow_application_object_id="$(az ad app list \
  --display-name "$workflow_application_name" \
  --query '[0].id' \
  --output tsv)"

if [[ -z "$workflow_application_object_id" ]]; then
  workflow_application_object_id="$(az ad app create \
    --display-name "$workflow_application_name" \
    --query id \
    --output tsv)"
fi

workflow_client_id="$(az ad app show \
  --id "$workflow_application_object_id" \
  --query appId \
  --output tsv)"

workflow_service_principal_id="$(az ad sp list \
  --filter "appId eq '$workflow_client_id'" \
  --query '[0].id' \
  --output tsv)"

if [[ -z "$workflow_service_principal_id" ]]; then
  workflow_service_principal_id="$(az ad sp create \
    --id "$workflow_client_id" \
    --query id \
    --output tsv)"
fi

federated_credential_name="github-$github_environment"
federated_credential_subject="$github_oidc_subject_prefix:environment:$github_environment"
federated_credential_count="$(az ad app federated-credential list \
  --id "$workflow_application_object_id" \
  --query "length([?name == '$federated_credential_name'])" \
  --output tsv)"

if [[ "$federated_credential_count" == '0' ]]; then
  az ad app federated-credential create \
    --id "$workflow_application_object_id" \
    --parameters "{\"name\":\"$federated_credential_name\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"$federated_credential_subject\",\"description\":\"GitHub Actions deployment for $github_repository\",\"audiences\":[\"api://AzureADTokenExchange\"]}" \
    --output none
else
  az ad app federated-credential update \
    --id "$workflow_application_object_id" \
    --federated-credential-id "$federated_credential_name" \
    --parameters "{\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"$federated_credential_subject\",\"description\":\"GitHub Actions deployment for $github_repository\",\"audiences\":[\"api://AzureADTokenExchange\"]}" \
    --output none
fi

resource_group_scope="/subscriptions/$subscription_id/resourceGroups/$resource_group_name"
contributor_assignment_count="$(az role assignment list \
  --assignee "$workflow_service_principal_id" \
  --scope "$resource_group_scope" \
  --query "length([?roleDefinitionName == 'Contributor'])" \
  --output tsv)"

if [[ "$contributor_assignment_count" == '0' ]]; then
  az role assignment create \
    --assignee-object-id "$workflow_service_principal_id" \
    --assignee-principal-type ServicePrincipal \
    --role Contributor \
    --scope "$resource_group_scope" \
    --output none
fi

gh api \
  --method PUT \
  "repos/$github_repository/environments/$github_environment" \
  --silent

printf '%s' "$workflow_client_id" | gh secret set AZURE_CLIENT_ID --env "$github_environment" --repo "$github_repository"
printf '%s' "$subscription_id" | gh secret set AZURE_SUBSCRIPTION_ID --env "$github_environment" --repo "$github_repository"
printf '%s' "$tenant_id" | gh secret set AZURE_TENANT_ID --env "$github_environment" --repo "$github_repository"
gh variable set CREATURELY_SITE_URL \
  --env "$github_environment" \
  --repo "$github_repository" \
  --body "https://$default_hostname"

echo "Configured the $github_environment GitHub environment, Azure identity, and canonical site URL."
echo "Site URL: https://$default_hostname"
