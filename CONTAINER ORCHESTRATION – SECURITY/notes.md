kubeapiserver=center of all operation in kubernetes
we interact with it thorugh the kubectl utility or by  accesing the API directly and through that , you can perform almost any operation on the cluster.

we need to take 2 type of decision=
1.who can access=
-defined by authentication mechanism
-authentication way:-
  Files-username and password
  Files-username and tokens
  certificates
  external authentication providers -LDAP
  Service Accounts
2. what can they do?
- RBAC Authorization=role base 
- ABAC Authorization=attribute base
- Node Authorization
- webhook Mode

service accounts of cluster
- application and users (not inclide in course)
users=
    1. Admins
    2. Developers
service Accounts
- bots

-->kubectl create serviceaccount sa1
-->kubectl get serviceaccount


kubeapiserver authentication mechanism=
1.  Files-username and password=we store username and password in .csv file.
a.kube-apiserver.service file=
ExecStart=--basic-auth-files=user-details.csv
b.pod.yaml=
syntax=
- spec:
    containers:
    - command:
      - --basic-auth-files=user-details.csv

##genreate ssl certificates
1.easyrsa
2.openssl
3.cfssl
#openssl
1. certificate Authority (CA)
genreate certificate
-->openssl genrsa -out ca.key 2048 => ca.key
certificate signing request
-->openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr => ca.csr
sign certificate
-->openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt

2. admin user certificate(create certificate for new user)
genreate certificate
-->openssl genrsa -out admin.key 2048 => admin.key
certificate signing request
-->openssl req -new -key admin.key -subj "/CN=kube-admin(any name)" -out admin.csr => admin.csr
    master account=
    -->openssl req -new -key admin.key -subj "/CN=kube-admin(any name)/O=system:masters" -out admin.csr => admin.csr
sign certificate
-->openssl x509 -req -in admin.csr -signkey admin.key -out admin.crt


# etcd server
-->cat etcd.yaml

# kubeapi server=every operation in the cluster is going through kubeapiserver.
-alternate name of kubeapiserver=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,cluster-IPs
-syntax
-->openssl genrsa -out apiserver.key 2048 => apiserver.key
certificate signing request
-->openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" -out apiserver.csr => apiserver.csr

give alternate name in cluster=openssl.cnf
-->openssl x509 -req -in apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver.crt -extensions v3_req -extfile openssl.cnf-days 1000 => apiserver.crt

# kubelet server=

## kube config=
login as admin user=
-->curl https://my-kube-playground: 6443/api/v1/pods \
      --key admin.key
      --cert admin.crt
      --cacert ca.crt

-->kubectl get pods --server my-kube-playground: 6443 --client-key admin.key --client-certificate admin.crt -certificate-authority ca.crt

but every time pass the key is too lenghty,so we create kube-config file. 
-->kubectl get pods --kubeconfig config
if you write a config file in home directory then you don`t need give any config file name in cmd.

# kubeconfig file=kube-config-main.yaml

-->kubectl confign view --kubeconfig=my-custom-config
-->kubectl config use-context prod-user@production
convert ca.crt into base64 encode=
-->cat ca.crt | base64=>"Ls..nJ"
decode the code=
-->echo "Ls..nJ" | base64 --decode

## api groups=
all groups available in the cluster=
-->curl http://localhost:6443 -k

service available available in the apis group
--> curl http://localhost/apis -k | grep "name"


# kube proxy != kubectl proxy
kubectl proxy is an http proxy service created by kubeapi server

## authorization

## RBAC=role-based-authorization
developer-role.yaml
devuser-developer-binding.yaml
--> kubectl get roles
--> kubectl get rolebindings
--> kubectl describe role developer
-->kubectl get rolebindings devuser-developer-binding

# check access= "can-i" command || yes/no output
-->kubectl auth can-i create deployments
-->kubectl auth can-i delete deployments
  by the users
-->kubectl auth can-i delete deployments --as dev-user

## cluster role=when user authorize to  cluster-wide resources you user cluster role.
# Namespaced=pods,replic,sets,jobs,deployments,services,secrets etc.
-->kubectl api-resources --namespaced=true
# cluster Scoped=nodes,Persistent volume (PV),clusteroles,clusterolesbindings,certificatesrequest,namespaces
-->kubectl api-resources --namespaced=false

cluster-admin-role.yaml
cluster-admin-role-binding.yaml


## service Accounts
2 type account=
1.user account=admin,developer
2.service account=promethus,jenkins

--> kubectl create serviceaccount dashboard-sa
--> kubectl get serviceaccount
these commandgive a token for authorization. to see token=
  --> kubectl describe serviceaccount dashboard-ca
  -->kubectl describe secret <token-name>
# every namespace have seprate volume for saving secrets.
-->kubectl describe pod <pod-name> =>give volume name
-->kubectl exec -it my-kubernetes-dashboard ls <volume-path>
-->kubectl exec -it my-kubernetes-dashboard cat <volume-path>/token
#this token does not have any expiry date.but in v1.24 hav not any token with default serviceaccount.
-->kubectl create serviceaccount dashboard-ca
-->kubectl create token dashboard-ca => <token>
decode the token -->ja -R 'split(".") | select(length > 0) | [0], [1] | @base64d | fromjson' <<< <token>


## image seurity
syntax=
spec:
  containers:
  - name:
    image:nginx

actual address of nginx=docekr.io/library/nginx(registry/user-account/registry-name)
#this is for public registry but when you have private registry then
-->docker login private-registry.io
-->docker run private-registry.io/apps/internal-app
#nginx-privatepod.yaml
create secret for docker login=
-->kubectl create secret docker-registry regcred \--docker-server= private-registry.io --docker-username= registry-user --docker-password=registry-password --docker-email= registry-user@org.com

  regcred = credetials for docker login


## security context
syntax=
spec:
  containers:
   - name: ubuntu
     command: ["sleep", "3600"]
     securityContext:
        runAsUser: 1000
        capabilities:
          add: ["MAC_ADMIN]

# kubernetes pod security=it is 2 way
  1.security apply on pod=if securityapply on pod, it apply all the containers with in the pod
  2.security apply on containers=f securityapply on containers, it override the pod securit rules.

## network policies
# ingress= incoming traffic 
# agress=out-going traffic 
# allow ingress traffic from api pod on port 3306
syntax=network-policy.yaml
#Solutions that Support Network Policies:
• Kube-router
• Calico
• Romana
• Weave-net
Solutions that DO NOT Support Network Policies:
• Flannel
 


