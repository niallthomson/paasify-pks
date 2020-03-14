# Paasify PKS on AWS

## Required Inputs

The following input variables are required:

### availability\_zones

Description: List of AWS availability zones in which to deploy the foundation

Type: `list(string)`

### dns\_suffix

Description: The suffix of the DNS domain that will be used (ie. aws.paasify.org)

Type: `string`

### env\_name

Description: The name of the environment, used to name resources and DNS domains

Type: `string`

### pivnet\_token

Description: Token for Pivotal Network used to download assets

Type: `string`

### pks\_version

Description: The major version of PKS to install (ie. 1.6)

Type: `string`

### region

Description: The AWS region in which to deploy the foundation (ie. us-west-2)

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### encrypt\_pas\_buckets

Description: Apply KMS encryption to S3 buckets used for PAS

Type: `string`

Default: `"1"`

### ops\_manager\_instance\_type

Description: AWS EC2 instance type used for OpsManager

Type: `string`

Default: `"r4.large"`

### tiles

Description: List of names of tiles to install with PAS

Type: `list(string)`

Default: `[]`

### vpc\_cidr

Description: The CIDR of the AWS VPC that will be created for this foundation

Type: `string`

Default: `"10.0.0.0/16"`

## Outputs

The following outputs are exported:

### harbor\_admin\_password

Description: Harbor admin password

### harbor\_endpoint

Description: Harbor endpoint

### ops\_manager\_domain

Description: Domain for accessing OpsManager

### ops\_manager\_password

Description: Password for accessing OpsManager

### ops\_manager\_ssh\_private\_key

Description: SSH private key for accessing OpsManager

### ops\_manager\_username

Description: Username for accessing OpsManager

### pks\_admin\_password

Description: Admin username for PKS

### pks\_admin\_username

Description: Admin username for PKS

### pks\_api\_endpoint

Description: API endpoint for PKS

### provisioner\_host

Description: Hostname for accessing provisioner instance

### provisioner\_ssh\_private\_key

Description: SSH password for accessing provisioner instance

### provisioner\_ssh\_username

Description: SSH username for accessing provisioner instance

