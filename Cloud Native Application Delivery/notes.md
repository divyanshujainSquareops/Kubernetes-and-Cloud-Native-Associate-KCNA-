## GitOps Principles
# Cloud Native Computing Foundation (CNCF)
- it provide a neutral home for the project ensuring that it remains vendor neutral and community driven,
- four core principle
    1. declecrative
    2. version and immutable= the canonical desired system state is versioned in GIT.once rthe yaml file applied to the kubernetes cluster , it becomed immutable.we do not make any changes directly,but instead we create a new version of the file to make updates.
    3. pullled automatically=approved changes applied to the system.for deploy we use gitops agent Flux or ArgoCD to automate the process.
    4. continuously reconcile=it is software agents to ensure correctness and alert on divergence.

## Push vs Pull-based Deployments
- 2 approact for deployment process
    1. push based=for this approach you have to expose cluster credentials in the CD pipeline.
    2. pull based =this is achievd through use an operator that is deployed within the associated git repo and docker registeries for changes.if the change detected the operator update the cluster.

## CI/CD with GitOps
in gitops we use 2 repos=
1. application code repo=for application code,resources, configuration,data, images.
2. kubernetes manifestes repo=contain yaml file that describe the desired state  of the cluster. it includes deployment ,service,ingress,configmap,secret and other kubernetes resources.
- for deployment gitops we use argoCD operator continously monitors the kubernetes manifest repo for changes an reconciles the desired state with the actual state of the cluster. it deployes update and release resources.

## Git Repositories, Dockerfile and Application Walkthrough
## ArgoCD Walkthrough
## CICD Pipeline Demo