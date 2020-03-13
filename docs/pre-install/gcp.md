# Paasify PKS on GCP

## Pre installation instructions

It's highly recommended to restrict access to your Kubernetes clusters.  Therefore, create a jumpbox in your Google cloud account, and install [Git](https://git-scm.com/downloads) and [Terraform](https://www.terraform.io/downloads.html).

### Prerequisites

* A Google Cloud [account](https://cloud.google.com/gcp/getting-started)

You should have the [gcloud](https://cloud.google.com/sdk/install) SDK installed on your workstation.  Or just launch a [Google Cloud Shell](https://cloud.google.com/shell).

### Scripts

Consider using the install script below to create a Linux jumpbox

```
#!/bin/sh

# Create your jumpbox from your local machine or Google Cloud Shell
## Expects that an environment variable named GCP_PROJECT_ID has already been exported

gcloud auth login --project ${GCP_PROJECT_ID} --quiet

gcloud services enable compute.googleapis.com \
  --project "${GCP_PROJECT_ID}"

gcloud compute instances create "jbox-cc" \
  --image-project "ubuntu-os-cloud" \
  --image-family "ubuntu-1804-lts" \
  --boot-disk-size "200" \
  --machine-type=g1-small \
  --project "${GCP_PROJECT_ID}" \
  --zone "us-west1-a"
```
> `create-jumpbox.sh`

SSH into the jumpbox

```
#!/bin/sh

# Connect to the jumbpbox
GCP_PROJECT_ID={project_id}

gcloud compute ssh ubuntu@jbox-cc \
  --project "${GCP_PROJECT_ID}" \
  --zone "us-west1-a"
```
> `connect-to-jumpbox.sh`

Authenticate (once) to Google Cloud

```
#!/bin/sh

# Authenticate and authorize the jumpbox to work with project on Google Cloud Compute
gcloud auth login --quiet
```

Install Git and Terraform

```
#!/bin/sh

# Install necessary tools on jumpbox

sudo apt update --yes && \
sudo apt install --yes git

cd ~

TF_VERSION=0.12.23
wget -O terraform.zip https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
  unzip terraform.zip && \
  sudo mv terraform /usr/local/bin && \
  rm terraform.zip
```

Clone the repository

```
git clone https://github.com/niallthomson/paasify-pks
```

Add environment variables

Set three environment variables.  You might want to put these into a `.env` file located in your `/home/ubuntu` directory and append `source ~/.env` to your `.bashrc` file.  `GOOGLE_CREDENTIALS` must be a single line devoid of newlines or carriage returns.  Escape occurrences of newline within the `private_key`.  A sample appears below, adapt for your needs.

```
GOOGLE_CREDENTIALS={ "type": "service_account", "project_id": "change_me", "private_key_id": "change_me", "private_key": "-----BEGIN PRIVATE KEY-----change_me-----END PRIVATE KEY-----\n", "client_email": "change_me@{project_id}.iam.gserviceaccount.com", "client_id": "change_me", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://accounts.google.com/o/oauth2/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/change_me" }
GOOGLE_PROJECT={project_id}
GOOGLE_REGION={region}
```
> `.env`
