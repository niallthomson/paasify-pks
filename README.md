# Paasify for Pivotal Container Service

![](https://github.com/niallthomson/paasify-pks/workflows/CI/badge.svg)

Install Pivotal Container Service with nothing more than Terraform. If you need fire-and-forget mechanism that gives you predictable, disposable PKS environments (including popular tiles) in your own cloud accounts then this is for you.

The goal of this project is to allow you to complete an install of PKS, including optional tiles, with the only requirement being Terraform. This is being essentially being exposed as 'PKS-as-a-Terraform-module' that is compatible across all supported public clouds. It is designed for short-term, non-production setups, and is not intended to provide a PAS setup that can be upgraded over long periods of time.

| AWS | GCP | Azure | VMware |
|------|-----|-----|-----|
| [Docs](docs/modules/aws.md) | [Docs](docs/modules/gcp.md) | :x: | :x: |

Note: This project requires Terraform 0.12.X

Take this example:

```
module "pks" {
  source = "github.com/niallthomson/paasify-pks//aws"

  env_name     = "paasify-test"
  dns_suffix   = "aws.paasify.org"
  pivnet_token = "<pivnet token here>"

  pks_version  = 1.6

  region             = "us-west-2"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  tiles = ["harbor"]
}
```

This will:
- Install PKS 1.6
- Download, stage and configure the Harbor tile
- Wire up DNS so that its accessible at `paasify-test.aws.paasify.org`
- Provision valid SSL certificates via Lets Encrypt for every common HTTPS endpoint
- Allow you to cleanly tear down all infrastructure via `terraform destroy`
- Perform all PivNet product downloads/uploads on a jumpbox VM for speed

When the Terraform run completes there will be a fully working PKS installation, with endpoint information available from Terraform outputs.

## Reference

Quick reference for various areas of the project.

### Prerequisites

The following are pre-requisites for working with Paasify:
- Understand how to provide cloud credentials, which is documented [here](https://github.com/niallthomson/paasify-core/docs/handling-cloud-credentials.md).
- DNS setup appropriately for your cloud of choice. See [here](https://github.com/niallthomson/paasify-core/docs/dns-setup.md) for details on how your DNS should be setup.
- Terraform 0.12.X installed

### Tiles

The following table lists all tiles that can be automatically installed, along with the name that should be put in the `tiles` parameter:

| Tile | Name| 1.6 |
|------|-----|-----|
| Harbor | `harbor` | :white_check_mark: |

The latest stemcell supported by each tile will automatically be uploaded to OpsManager.