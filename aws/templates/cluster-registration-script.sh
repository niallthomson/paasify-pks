export AWS_DEFAULT_REGION=${region}

instance_id=$(aws ec2 describe-instances --filters "Name=tag:job,Values=master" --filters "Name=tag:deployment,Values=service-instance_$service_instance" | jq -r '.Reservations[0].Instances[0].InstanceId')

aws elb register-instances-with-load-balancer --load-balancer-name ${lb_name} --instances $instance_id