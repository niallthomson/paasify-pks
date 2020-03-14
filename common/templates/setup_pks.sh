#!/bin/bash

set -e

if [ ! -f $HOME/.uaa ]; then
  sudo apt install -y build-essential ruby ruby-dev

  sudo gem install cf-uaac

  uaac target https://${api_endpoint}:8443 --skip-ssl-validation

  admin_secret=$(om credentials -p pivotal-container-service -c .properties.pks_uaa_management_admin_client -t json | jq -r '.secret')

  uaac token client get admin -s $admin_secret

  uaac user add paasify --emails paasify@localhost -p ${pks_password}

  uaac member add pks.clusters.admin paasify

  touch $HOME/.uaa
fi

mkdir $HOME/pks-download

pivnet download-product-files -p pivotal-container-service -r ${pks_version} -g "pks-linux-amd64*" -d $HOME/pks-download

sudo mv $HOME/pks-download/pks-linux-amd64* /usr/local/bin/pks

sudo chmod +x /usr/local/bin/pks

cat << EOF > $HOME/pks-login.sh
pks login -a https://${api_endpoint}:9021 -u paasify -p ${pks_password} -k
EOF

chmod +x $HOME/pks-login.sh