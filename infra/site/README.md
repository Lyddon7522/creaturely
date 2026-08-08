# Creaturely website infrastructure

This deployment unit owns the Azure resources for the Creaturely public website:

- `creaturely-prod-rg-01`, an application-specific resource group
- `creaturely-prod-swa-01`, a Free-tier Azure Static Web App

DNS is intentionally out of scope. The site uses the generated Azure hostname
until a custom domain is selected and attached.

## First deployment

Prerequisites:

- Azure CLI signed in to the intended tenant and subscription
- GitHub CLI signed in with access to this repository

Preview and deploy the infrastructure:

```sh
export AZURE_TENANT_ID='<tenant-id>'
export AZURE_SUBSCRIPTION_ID='<subscription-id>'
./infra/site/deploy.sh --what-if
./infra/site/deploy.sh
```

The script creates the resource group and Static Web App, then configures a
passwordless GitHub OIDC application with Contributor access limited to the
Creaturely site resource group. Azure identifiers are stored as secrets in the
`prod` GitHub environment. The public Azure hostname is stored as the
`CREATURELY_SITE_URL` environment variable so production builds can generate
canonical and sitemap URLs.

The workflow reads the Static Web App deployment token from Azure after OIDC
sign-in. No deployment token or client secret is stored in GitHub.

## Ongoing deployment

The site workflow:

- validates every in-repository pull request that changes the website;
- publishes a temporary Azure preview for each eligible pull request;
- removes that preview when the pull request closes; and
- deploys production after a direct push or merged pull request reaches `main`.

Production runs reapply `main.bicep` before uploading the already-built static
files. Changes to `bootstrap.bicep` still require an intentional local run of
`deploy.sh` because the workflow identity is limited to the application resource
group.

When a custom domain is ready, attach it in Azure and update the
`CREATURELY_SITE_URL` variable in the `prod` GitHub environment.
