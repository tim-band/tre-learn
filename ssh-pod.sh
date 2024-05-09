app_name=ScalableTreLearn
names=($(kubectl get pod --output=json | jq -r '.items | map(select(.kind=="Pod" and .metadata.labels.App=="'${app_name}'"))[].metadata.name'))
kubectl exec --stdin --tty ${names[0]} -- sh
