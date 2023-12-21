# how sheduler works=it check every pod ,and find pod which not have same property of the other pod.
# what work of sheduler=it add the property in choose pod , and make the same property which same to other pod.
# sheduler work called pod-bind.
# syntax nodeName

## labels
-->kubectl get pods --selector app=App1
replicaset code m 
1.metadata m code hota hai vo replicaset se related hota hai
2.template m jo labels hote hai vo pod se related hote hai 

-->kubectl label nodes <node-name> key=value

## annotations=to record additional details or metadata for informational purposes.

## taints and toleration=
small story=ek bug jo insall ko katna chata hai , lekin usne ek cream lga rakhi hai
1.agar bug us cream ki smell ko sahan nhi kar pata toh person kaatnhi payega
2.agar bug us cream ki smell ko sahan kar pata toh person kaat payega

that same case with node and pods
1.if node selector match with pod then pod enter the node
2.if node selector not match with pod then pod not enter in the node
#taints are set on node and toleration set  on pods

-->kubectl taint nodes node-name key=value:taint-effect
taint effect=
1.NoSchedule=pod will not Schedule with node
2.PreferNoSchedule=pod will try not Schedule with node
3.NoExecute=pod will evicted immediately from the node, if they do not tolerate the taint.

toleration add with pods. it write in the yml file , in the "spec" selection.
spec:
    toleration:
    - key: "app" (pod name)
      operator: "Equalt (=,!=)
      value: "blue" ()
      effect: "NoSchedule" (taint effect)


## node selector=set a limitation on pods so that only run on particular node
2way to do this
1.node selector
spec:
    nodeSelector:
        size: Large

size:Large= its like a lables which give to the pods
-->kubectl label nodes <node-name> <label-key>=<label-value>
-->kubectl label nodes node-1 size-Large
limitation=it have only 2 value large or medium, but we have diffrent requirement.that cause we go with the "affinity".

## affinity=enables complex queries like OR,IN,Not and EXISTS for limiting pod placement on specific nodes.
spec:
    affinity:
        nodeaffinity:
            requiredDuringSchedulingIngoreDuringExecution:
                nodeSelectorTerms:
                    - matchExperssions:
                      - key: size
                      operator: Exists 
        
Node affinity types:
1.Available
  -requiredDuringSchedulingIgnoredDuringExecution 
  -preferredDuringSchedulingIgnoredDuringExecution
1.Planning
  -requiredDuringSchedulingRequiredDuringExecution 
  -preferredDuringSchedulingRequiredDuringExecution

if you want that all pod are work with your selected nodes. then you need taint&toleration with affinity.
taint&toleration protect with the other nodes and affinity labels to node that helps to pod find perfect match node .


## Resorurce Request=
spec:
    resorurces:
        requests:
            memory: "1Gi"
            cpu: 1

CPU= min possible value is 1m(mili).
CPU= min possible value is 1G(gigabyte).
default limit=0.5vCPU,256Mi
set new limit in yml=
spec:
    resorurces:
        limits:
            memory: "2Gi"
            cpu: 2

## daemon sets=it ensure that one copy of pod is always present in the cluster.
usecase=
1.monitoring=you can deploy monitoring agent with the daemon.
2.logs viewer=
3.kube-proxy=
4.wwave-net

syntax=daemonset.yml 
-->kubectl get daemonsets

##Static pods=pods that are created by the kubelet on its own without intervation from the apiserver or rest of the kubernetes cluster components as known as Static pods.

--pod-manifest-path=/etc/kubernetes/manifests
custom static pod=replece(--pod-manifest-path)with 
--config=kubeconfig.yaml
kubeconfig.yaml(staticPodPath: /etc/kubernetes/manifests)

static pod commands=
1.sqw static pod=docker ps
why we use dockr commands=bcz kubernetes have not any apiserver for the static pods.

Q.kubelet can create static pod or normal pod at same time?
A.yes it can create static pod and onrs from the API server, at the same time.

#static pod also create mirror image in kubeapiserver , it is the readonly copy of the pod.
you can static pod by modify only by the manifest file

usecase= we can deploy Control Plane components (deployment,replicaset)as staticpod.
 
diffrence staticpod vs daemonsets=
1.create=kubelet||daemonset
2.deploy=Controlplab || monitoring or logging agnet

same in staticpod & daemonsets=ignore by kube-Scheduler
  
## multiple scheduler
new-scheduler=
ExecStart=/use/local/bin/kube-scheduler \\
    --config=/etc/kubernetes/config/my-scheduler-2-config.yaml
#configure the new scheduler to pod or deployment to use this new scheduler.
syntax=
spec:
    schedulerName: my-custom-scheduler

Q.how you know that which scheduler picked up particular pod?
A. -->kubectl get events -o wide

kubeScheduler Log=
-->kubectl logs custom-scheduler --name-space=kube-system

## configuring kubernetes scheduler profiles
1. scheduler queue=
prioritySort=choose which scheduler have high priority 
--in pod.yml syntax
spec:
    priorityClassName: high-priority

2. Filtering
-NodeResourceFit
-nodeName
-NodeUnschedulable

3. Scoring
-NodeResourceFit
-ImageLocality

4. Binding
-DefaultBinder

# these all type scheduler plugin are Available which  provide custom code which used where you want.

