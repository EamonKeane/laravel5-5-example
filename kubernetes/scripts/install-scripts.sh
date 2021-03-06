namespace=laravel5
mysql_release_name=mysql
laravel5_release_name=laravel5

helm install stable/mysql --wait --timeout 400 --namespace ${namespace} --set mysqlRootPassword=imApMsfoDt,mysqlDatabase=homestead --name ${mysql_release_name}

kubectl create secret generic --namespace ${namespace} laravel5-env --from-file=/Users/Eamon/PhpstormProjects/laravel5-5-example/.env

kubectl create secret generic --namespace ${namespace} laravel5-env-seeder --from-file=/Users/Eamon/PhpstormProjects/laravel5-5-example/.env

# When no storage volume dynamic privsioner is available, PV and PVC need to be create separately for the mysql chart
#kubectl apply -f /Users/Eamon/PhpstormProjects/laravel5-5-example/kubernetes/kubernetes-yaml/mysql-pvc.yaml
#kubectl apply -f /Users/Eamon/PhpstormProjects/laravel5-5-example/kubernetes/kubernetes-yaml/mysql-pv.yaml
#helm install stable/mysql --namespace ${namespace} --name mysql --set persistence.existingClaim="mysql-mysql",mysqlRootPassword=imApMsfoDt,mysqlDatabase=homestead

helm install --namespace ${namespace} --name laravel5 kubernetes/helm/laravel5

helm install --namespace ${namespace} --name laravel5 kubernetes/helm/laravel5 --set phpfpmImage.tag=orig

kubectl patch deployment --namespace ${namespace} laravel5-phpfpm --patch '{"spec": {"template": {"spec": {"containers": [{"name": "laravel5-phpfpm","image": "quay.io/eamonkeane/laravel:no-artisan"}]}}}}'

helm upgrade --install --wait --timeout 400 --namespace ${namespace} laravel5 kubernetes/helm/laravel5