#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pks_api_endpoint=$(terraform output pks_api_endpoint)
pks_admin_username=$(terraform output pks_admin_username)
pks_admin_password=$(terraform output pks_admin_password)

echo "Authenticating to PKS with username '$pks_admin_username' and password '$pks_admin_password'"
echo ""

pks login -a $pks_api_endpoint -u $pks_admin_username -p $pks_admin_password --skip-ssl-validation