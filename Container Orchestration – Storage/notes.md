## Docker Storage
in docker storge there are 2conept=
1. storage drivers = aufs,zfs,btrfs, device mapper, overlay,overlay2
2. volume drivers = Local,Azure File Storage,Convoy,
DigitalOcean Block Storage,Flocker,gce-docker,GlusterFS,NetApp,RexRay ,Portworx,VMware vSphere Storage

file system=
- it create a folders structure
folder path= /var/lib/docker
it have more folders
- aufs, containers, image, volume
# layerd architecture
- docker have 2 main layers image layers or container layers.
- image layer= it is read only layer. its creates when you create a image. after build is complete you can not modify this layer.
     image layer run cmd=
     -->docker build .
- container layer=
    cmd=
    -->docker rum <image>
  when you run cmd , it create container layer. it writeable layer.
  use= store data created by container such as log files , temp files or modified file.
  this layer life depend on container life. container destroyed , it also destroyed.

# copy-on-write=
 image layer is readonly. that means we can not modify image layer file?
- thats not true. docker create another version of image layers files in container layer. these files are writeable. it is called copy on right mechanism.

- these filed or any other file are delted when container destroyed. so this data not persistent.
- for securing this data, we creare docker volume
--> docker volume create data_volume
    location= /var/lib/docker/volumes/data_volume
- aatach volume to contaier
--> docker run -v data_volume:/var/lib/mysql mysql
- external folder attach to docker container
--> docker run -it /data:/var/lib/mysql mysql
- -v is old option , new option is -mount option.
    -->docker run --mount type=bind, source=/data/mysql, target=/var/lib/mysql mysql

- docker use storage drivers to enable layered architecture.
- docker choose autmoatically storage driver for the system.

## Volume Driver Plugins in Docker
- in docker volume do not handle by storge driver, it handle by volume driver plugins.
-->docker run -it --name=mysql --volume-driver rexray/ebs --mount src=ebs-vol target=/var/lib/mysql mysql

## Container Storage Interface
= it is a standard that defines how an kubernetes would communicate with container runtime line docker. 
- it define a set of remote procedure calls (RPS`s) that will be called by container orchestrator(kubernetes) and these must will be implemented by the storage driver.
ex:- when container is created, kubernetes should call the create volume RPC and pass a set of detail such as the volume name.

## Volumes in kubernetes
single node volume mount
-->volume-mount-pod.yaml
single node aws volume mount
-->volume-mount-pod-aws.yaml

## Persistent Volumes
# PVC= Persistent Volumes Claims 
- a persistent volume is a cluster-wide pool of storage volumes configured by an a administrator to be used by users deploying application on the cluster. the users can now select storage from this pool using persistent volume claims.

# persistent-volume-claim.yaml

## Persistent Volume Claims
- PV and PVC are diffrent objects.
- once the PVC are created, kubernetes binds the persistent volumes to claims based on the rquest and properties set on the volume.
- during the binding process, kubernetes tries to find a persistent volume that has sufficient capacity  as requested by the claim and any other request property such as access modes,volume modes, storage class etc.
# persistent-volume-claim.yaml
-->kubectl create -f persistent-volume-claim.yaml
-->kubectl get persistentvolumeclaim
# delete pvc=-->kubectl delete persistentvolumeclaim myclaim
- what is we have to save volume
    - persistentVolumeReclaimPolicy: Retain (bydefault)
    - persistentVolumeReclaimPolicy: Delete (if volume deleted claim will be deleted)
    - persistentVolumeReclaimPolicy: Recycle (the data in the data volume will be scrubbed before making it avaialable to other claims)

## Storage Class

- add pv or pvc to pod.yaml file
    syntex:
    spec:
        volumes:
        - name: data-volume
        persistentVolumeClaim:
            claimName: myclaim
- Static provisioning = before creating pv  cloud based persistance storage, you have to created volume in cloud.
    sysntax:-
    gcloud beta compute disks create --size 1GB --region us-east1 pd-disk
    - pass these cloud disk to PV.
    ex.=persistent-volume.yaml

# if would have been nice if the  volume gets provisioned automatically when the application require it and that`s where storage class comes.
- Dynamic provisioning:- it is provisioner such as google storage that can automatically provision storage on google cloud and attach that to pods when claim it mades.
# storageClass.yaml
- for pvc to use the storage class.
    syntax:-in persistent-volume-claim.yaml
    spec:
        storageClassName: google-storage
- if you created pvc , you dont hve to create pv anymore. it created automatically by the storage class.


    


