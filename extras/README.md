## How to generate manifests?
1. Install [Prerequisites](https://github.com/gluster/gluster-mixins#prerequisites)
2. `$ git clone https://github.com/gluster/gluster-mixins.git`
3. `$ cd gluster-mixins/extras`
4. `$ jb install`
5. `$ ./build.sh example.jsonnet`

Generated files are in `manifests` directory.

## How to apply manifests?
* In K8s cluster,

  `$ kubectl create -f manifests/ || true`

* In OC cluster,

  `$ oc create -f manifests/ || true`

## How to teardown?

* In K8s cluster,

  `$ kubectl delete -f manifests/ || true`

* In OC cluster,

  `$ oc delete -f manifests/ || true`
