app_name=ScalableTreLearn
names=($(kubectl get pod --output=json | jq -r '.items | map(select(.kind=="Pod" and .metadata.labels.App=="'${app_name}'"))[].metadata.name'))
kubectl port-forward pod/${names[0]} 32100:32100
