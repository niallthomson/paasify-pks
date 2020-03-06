#!/bin/bash

set -e

sudo apt install -y build-essential ruby ruby-dev

sudo gem install cf-uaac

uaac target https://${api_endpoint}:8443 --skip-ssl-validation

admin_secret=$(om credentials -p pivotal-container-service -c .properties.pks_uaa_management_admin_client -t json | jq -r '.secret')

uaac token client get admin -s $admin_secret

uaac user add paasify --emails paasify@localhost -p ${pks_password}

uaac member add pks.clusters.admin paasify