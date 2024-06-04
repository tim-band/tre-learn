set -eu
name="tre-learn"
ingress_port=33302
api_port=33301
vars_file="terraform.tfvars"
rancher_count=1
old_name=$(cat old_name || echo "")
if [ -n "${old_name}" ] && k3d cluster list ${old_name}
then
    k3d cluster delete ${old_name}
fi
k3d cluster create ${name} --servers ${rancher_count} --api-port 0.0.0.0:${api_port} --port "${ingress_port}:30201@loadbalancer"
echo ${name} > old_name
api_server=$(k3d kubeconfig get ${name} | yq '.clusters[0].cluster.server')
ca_cert=$(k3d kubeconfig get ${name} | yq '.clusters[0].cluster."certificate-authority-data"')
client_cert=$(k3d kubeconfig get ${name} | yq '.users[0].user."client-certificate-data"')
client_key=$(k3d kubeconfig get ${name} | yq '.users[0].user."client-key-data"')
echo "host=${api_server}" > ${vars_file}
echo "cluster_ca_certificate=${ca_cert}" >> ${vars_file}
echo "client_certificate=${client_cert}" >> ${vars_file}
echo "client_key=${client_key}" >> ${vars_file}
echo "Remember to call terraform apply!"
