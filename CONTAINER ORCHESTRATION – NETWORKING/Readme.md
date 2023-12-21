some ports are need to open in  master or worker node=
1. 6443*=kubernetes api servr,inbound,used by all
2. 2379-2380=etcd server,client api,inbound,used by kube-apiserver,etcd
3. 10250=kubernetes api ,inbound,used by self,control plane
4. 10251=kube-scheduler,inbound,used by self
5. 10252=kube-ctrl-manager,inbound,used by self

## pod networking
# networking model
-Every POD should have an IP Address
-Every POD should be able to communicate with every other POD in the same node.
-Every POD should be able to communicate with every other POD on other nodes without NAT.
create bridge n/w for node
-->ip link add v-net-0 type bridge
want to n/w up
-->ip link set dev v-net-0 up
add the ip-address for the pod
-->ip addr add 192.168.15.5/24 dev v-net-o

-->ip link add veth-red type veth peer name veth-red-br
-->ip link set veth-red netns red
-->ip -n red addr add 192.168.15.1 dev veth-red
-->ip -n red link set veth-red up
-->ip link set veth-red-br master v-net-0
-->ip nets exec blue ip route add 192.168.1.0/24 via 192.168.15.5
-->iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE

# create route
-->ip route add 10.244.2.2 via 192.168.1.12
# Container n/w interface
-Container Runtime must create network namespace
-Identify network the container must attach to
-Container Runtime to invoke Network Plugin (bridge) when container is ADDed.
-Container Runtime to invoke Network Plugin (bridge) when container is DELeted.
-JSON format of the Network Configuration

for more info about cni
-->ps -aux | grep kubelet
-cni bin directory path
-cni config directory path
-network plugin

-->ls /opt/cni/bin
cni bin directory have all the supported plugin
-->ls /opt/cni/bin

## CNI weave plugin=
it very helpful when you have big  n/w infrastructure. if you send a package to another pod of another route then weave help you better then other plugin.
Deploy Weeve=
-->kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$ (kubectl version | base64 |
tr -d '\n')"

-->kubectl get pods -n kube-system => give n/ws name
-->kubectl logs weave-net-5gcmb weave -n kube-system


## DNS kubernetes=
Dns resoultion within the cluster b/w the different component such as pods and service.
# what names are assigned to what objects
service dns name in cluster=
--> curl http://web-service
service in another namespace(apps)=
--> curl http://web-service.apps

DNS name in svc=
cluster.local->svc->apps->web-service
ex.=-->curl http://web-service.apps.svc.cluster.local

DNS name in pods(10.244.2.5)=
IP(with -)->apps->pod->cluster.local
ex.=-->curl http://10-244-2-5.apps.pod.cluster.local

# Service DNS records
# POD DNS records

## Ingress=
# proxy-server=
it is use to kubernetes provision ports to direct on port 80(http) or 443(https).

 if you have more then one svc in one cluster you need more then 1 load balancer, then you have to pay more. so in this case we use "ingress".

 ingress helps your user access your application using a sigle externally accessible URL that you can configure to route to differnet service within your cluster based on the URL path.at the same time, implement SSL security as well.

 ingress is like layer 7 LB.

 # ingrees deploy=
 1.Deploy=ingress controller((nginx,haproxy,traefik)+rules)
 we use mostly ngix for ingress bcz nginx have inbilt kubernetes monitoring .
 # ingress-controller-deployment.yaml
 # ingress-controller-service.yaml
 # ingress-controller-configuration.yaml
 # ingress-controller-serviceaccount(auth).yaml
 2.Configure=ingress resources(kubernetes cluster)
 cluster have 2 apps wear and watch.
 we have to connect ingress to wear app then
 # ingress-resources.yaml
 -->kubectl create -f ingress-resources.yaml
 -->kubectl get ingress
 - resources rules=
 rule1=www.my-online-store.com
  - path= /wear
  - path= /watch
  - path= /else
 rule2=www.wear.my-online-store.com
  - path= /
  - path= /returns
  - path= /support
 rule3=www.watch.my-online-store.com
  - path= /
  - path= /movies
  - path= /tv
 rule4= else
  - path= / (404 not found)

