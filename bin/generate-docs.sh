#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo -e '# Paasify PKS on AWS\n' > $DIR/../docs/modules/aws.md
terraform-docs --no-providers markdown document aws >> $DIR/../docs/modules/aws.md

echo -e '# Paasify PKS on GCP\n' > $DIR/../docs/modules/gcp.md
terraform-docs --no-providers markdown document gcp >> $DIR/../docs/modules/gcp.md