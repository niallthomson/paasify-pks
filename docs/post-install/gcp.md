# Paasify PKS on GCP

## Post installation instructions

At the completion of `terraform apply` you should see between 5 and 6 additional VM instances in your Google Cloud Console.

At this point you have the base cloud infrastructure to support creating PKS clusters.

To create and manage clusters we will need to complete some additional steps.

### 1. Install prerequisite software

You should download and install the following CLIs on your workstation or jumpbox

* [PKS CLI](https://network.pivotal.io/products/pivotal-container-service/#/releases/551663/file_groups/2369)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [BOSH CLI](https://bosh.io/docs/cli-v2-install/)

Consider using the install script below on a Linux jumpbox

```
#!/bin/sh

# Install additional software on jumpbox

sudo apt update --yes && \
sudo apt install --yes jq && \
sudo apt install --yes build-essential

cd ~

PIVNET_UAA_REFRESH_TOKEN=change_me

PIVNET_VERSION=1.0.1
wget -O pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} && \
  chmod +x pivnet && \
  sudo mv pivnet /usr/local/bin/

BOSH_VERSION=6.2.1
wget -O bosh https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_VERSION}-linux-amd64 && \
  chmod +x bosh && \
  sudo mv bosh /usr/local/bin/

pivnet login --api-token="${PIVNET_UAA_REFRESH_TOKEN}" && \
  pivnet download-product-files --product-slug='pivotal-container-service' --release-version='1.6.1' --product-file-id=579531 && \
  mv pks-linux-amd64-1.6.1-build.20 pks && \
  chmod +x pks && \
  sudo mv pks /usr/local/bin

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  sudo mv kubectl /usr/local/bin
```
> `tools.sh`

### 2. Login to PKS

If you haven't already, SSH into your jumpbox

```
cd paasify-pks/bin
./pks-login.sh
```

### 3. Follow procedure for creating and configuring load balancer and cluster

Each cluster will need a load balancer.

Carefully follow steps `1-7` underneath the `Overview` section of [Creating and Configuring a GCP Load Balancer for Enterprise PKS Clusters](https://docs.pivotal.io/pks/1-6/gcp-cluster-load-balancer.html)


#### Notes on naming

Stick with the name you chose for the cluster.  Use it consistently as a prefix for each cloud resource you will create.

Adopt a suffix convention for each cloud resource (e.g, load balancer `-lb`, IP address `-ip`).

The network tag on a compute instance for a master node in a cluster is just the name suffixed with `-master`.

The firewall rule should be prefixed with the sub-domain name, so name it something like

```
{sub-domain-name}.{cluster-name}-firewall
```
When configuring the firewall rule, be sure to obtain the public IP address for your jumpbox, and when prompted, choose a source filter (i.e., IP ranges), and enter a CIDR that includes IP address with `/32` (e.g., `38.227.140.195/32`).

#### How could the post-install procedure be improved?

Replace the manual steps above with automation; either we enhance the existing Terraform to complete these steps on our behalf, or we add a shell script.  Terraform is preferable as it may more appropriately disposition and manage the  life-cycle of the additional cloud resources that get created.

#### Load balancer remarks


* Consider setting up health checks
* Be wary of fact that IP address for load-balancer may change
  * if it does you'll need to update the `A` record DNS entry

## Addendum

### Sample commands

```
pks login -a https://api.pks.hagrid.ironleg.me -u paasify -p change_me --skip-ssl-validation
```
> PKS login

```
pks create-cluster dev-cluster-1 --external-hostname dev-cluster-1.hagrid.ironleg.me --plan small --num-nodes 3
```
> Create cluster

```
pks cluster dev-cluster-1
```
> Check-in on status of cluster creation

```
pks get-credentials dev-cluster-1
```
> Get credentials and set context

```
kubectl cluster-info
```
> Confirm you can access your cluster using the Kubernetes CLI