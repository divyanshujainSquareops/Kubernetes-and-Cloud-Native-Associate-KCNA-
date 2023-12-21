## types of service
we have 3 type svc=
1. NodePort=it will make accesible on a predefined port on all the node on the cluster
2. ClusterIP= internal service which created enable communication b/w application within the cluster.
3. Load Balancer=it support cloud load balancer.

## Sidecars
it is sidecar container (support container)in the pod,it handle file loading,log shipping,monitoring.
# sidecar-container.yaml

## Envoy 
 =proxy
 - open-source proxy designed for modern service-oriented architectured. 
 - it is worked as a sidecar for your container.
 - it handle traffic going in and out of our pod is using envoy as a proxy. 

 ## Monoliths & Microservices
 # Monoliths
 A monlithic Book info app have diffrent modules details,reviews,productpage, ratings and one DB.

data= authentication,authorization,networking,logging,monitoring,tracing.

this is very simple app, with simple functionality but you see that every module handle alot of data.
- when you increase some module capacity you have to take care of other possiblities.
- when you have to add one more module (campaign) you have to write alot of code.
- and these system might become a big ball of mud.

# micorservices
A micorservice Book info app have diffrent modules details (ruby),reviews (java) (with v1,v2,v3) ,productpage(python), ratings (node)and one DB.

# pros of microservice
- Scalablity
- Faster,smaller relaese
- Technology and language agnostic devlopment lifecycle.
- system resiliency and isolation.
- independent and easy to understand service

# cons of microservice
- complex service n/w
- security
- obervablity
- overload for traditional operation models

## Service Mesh
- def=It is a dedicated and configurable infrastructure layer that
handles the communication between services without
having to change the code in a microservice architecture.

- in service mesh we add a "proxy" sidecar container which is handle authentication,authorization,networking,logging,monitoring,tracing.it handle in or out data in pod. this proxy called envoy.
- control plane handle all module envoys.
- responsiblity = traffic management, security, observablity, service discovery (discovery,health check, load balancing)

## ISTIO
it is open-source svc that provides an efficient way to secure ,connect and monitor service.
- Istio implements these proxies using an open-soure high performance proxy known.

originally control plane have 3 component Citadel,Pilot,Galley.
- citadel managed certificate generation.
- pilot managed service discovery.
- galley helped in validating configuration files.

- istiod = these three component were later combined into a single daemon call "istiod".
- istio agent= envoy proxy

## Installing Istio
- --> istioctl install --set profile=demo -y
- istio system have 2 more component (with isitiod) Istio-ingressgateway, istio-egressgateway.
- verity istio install or not
--> istioctl verify-install

## Deploying our First Application on Istio
- first we have to enable istio-injection for the namespace.
--> kubectl label namespace default istio-injection=enabled
if you do not enable istio-injection then sidecar container "proxy" is not start.
--> kubectl apply -f bookinfo.yaml
--> istioctl analyze









