# BOSH Minio Release

[BOSH](http://bosh.io/) allows users to easily version, package and deploy software in a reproducible manner. This repo provides BOSH release of [Minio](https://github.com/minio/minio) Object Storage Server. You can use this release to deploy Minio in standalone, single-node mode as well as in distributed mode on multiple nodes.

## Upload release
Upload minio release to the bosh director.

```
bosh upload-release https://github.com/minio/minio-boshrelease/releases/download/RELEASE.2017-08-05T00-00-53Z/minio.tgz
```

## Deploy

### Standalone Minio deployment

``` shell
bosh deploy -d minio manifest/manifest-fs.yml
```

### Distributed Minio deployment

For deploying a distributed version, set the number of desired instances in the manifest file.

``` shell
bosh deploy -d minio manifest/manifest-dist-4node.yml
```
