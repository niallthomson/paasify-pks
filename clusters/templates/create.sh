$HOME/pks-login.sh

pks create-cluster ${name} -e ${endpoint} -p small --wait --non-interactive

service_instance=$(pks cluster ${name} --json | jq -r '.uuid')

${register_script}