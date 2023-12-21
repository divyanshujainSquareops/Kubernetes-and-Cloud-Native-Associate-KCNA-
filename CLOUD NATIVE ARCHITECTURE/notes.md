## Autoscaling
- it refers to automatically adjusting the number of resources such as servers ,VM,or application instance based on the demand of an application or svc.
- this ensure that the application can handle spikes or dropes without overloading and underutilizing resources.
- 3 factors of autoscalling
    • Designed for Scale
    • Automatic
    • Bidirectional - Scale up and down
- Vertical Scalling=adding more resources in single unit.
- horizontal scalling=increase units of single unit.
- 3 distinct features to manage and optimize resources efficiently.
    • Horizontal Pod Autoscaler
    • Vertical Pod Autoscaler
    • Cluster Autoscaler

## Horizontal Pod Autoscaler
- it is same as kubernetes control plane. when load increase it increase the pods and when load decrease it decrease the pods .
- it scale using metrics server outputs.
# horizontal_pod_scaller.yaml

## Vertical Pod Autoscaler
- VPA have 3 compnents=
    1. VPA recommender=it have metrics server
    2. VPA updater
    3. VPA admission controller=it intercept the new pod creation request and updates the    pods resource request to allign with the recommenders suggestion.
- vpa not available in kuberenetes , you have to install it.
    -->git clone https://github.com/kubernetes/autoscaler.git
    -->cd autoscaler/vertical-pod-autoscaler/
    -->./hack/vpa-up. sh
# vertical_pod_autoscaller.yaml

## Cluster Autoscaler
-->gcloud container clusters create my-cluster --cluster-autoscaler=min-nodes=3, max-nodes=10
- it is diffrent for diffrent cloud provider.

## Serverless
- serverless provide by diffrent cloud provider.
- FAAS function-as-a-service
- pay as you go model

## Kubernetes Enhancement Proposals (KEPs)
- it provide a standard way for members of the community to propose and discuss idea which makes it easier for everyone to understand and participate in the process.
- kaps allow for more detailed and sturctured disucssion which can help the community to  more carefully consider  and evaluate proposed changes.
- how keps work?
    - heading=4 digit number followed by a short title.
- sig(special intrest group)= sig members choose what changes are applied or declined in future release version of kuberenetes.
    it works on diffrent task=
    1. cpde devlopment
    2. testing and validation
    3. documentation
    4. community outreach and education.
    5. release management
    6. Architecture and design
## Open Standards
- it specification or protocols , formats that are openly available to the public and are developed through a collaborative and consensus-based process.
- it is designed to promote interoperability,portablity, and vendor neutrality.
- OCI (open container images)= it create container images , run time and distribution.