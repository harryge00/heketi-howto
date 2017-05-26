## 一个使用configmap来配置的heketi pod

```
kubectl create secret generic ssh-key-secret --from-file=id_rsa=/path/to/.ssh/id_rsa --from-file=id_rsa=/path/to/.ssh/id_rsa.pub #创建ssh key 
kubectl create -f heketi-configmap.yaml
kubectl create -f heketi-deployment.yaml
```
