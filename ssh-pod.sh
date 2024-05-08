names=($(kubectl get pod --output=json | jq -r '.items | map(select(.kind=="Pod" and .metadata.labels.App=="ScalableNginxExample"))[].metadata.name'))
kubectl exec --stdin --tty ${names[0]} -- /bin/bash
