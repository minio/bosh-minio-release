# BOSH Minio Release

[BOSH](http://bosh.io/) allows users to easily version, package and deploy software in a reproducible manner. This repo provides BOSH release of [Minio](https://github.com/minio/minio) Object Storage Server. You can use this release to deploy Minio in standalone, single-node mode as well as in distributed mode on multiple nodes.

## Upload release
Upload minio release to the bosh director.

```
bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease
```

## Deploy

Assuming there is a `disk_type` named `5GB` in your BOSH's `cloud config`.

``` shell
$ bosh cloud-config
...
disk_types:
- name: 5GB
  disk_size: 5_120
...
```

### Standalone Minio deployment

``` shell
$ bosh deploy -d minio manifests/manifest-fs-example.yml \
    -v minio_deployment_name=minio \
    -v minio_persistent_disk_type=5GB \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```

### Distributed Minio deployment

For deploying a distributed version, set the number of desired instances in the manifest file.

``` shell
$ bosh deploy -d minio manifests/manifest-dist-example.yml \
    -v minio_instances=4 \
    -v minio_deployment_name=minio \
    -v minio_persistent_disk_type=5GB \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```

### NAS Minio deployment

For deploying a minio backed by a NAS mounted directory.
In this example using NFS with the nfs_mounter job from the capi release.

``` shell
$ bosh deploy -d minio manifests/manifest-nas-example.yml \
    -v minio_deployment_name=minio \
    -v minio_nfs_server=12.34.56.78 \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```
