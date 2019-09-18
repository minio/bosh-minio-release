# MinIO BOSH Release

[BOSH](http://bosh.io/) allows users to easily version, package and deploy software in a reproducible manner. This repo provides BOSH release of [MinIO](https://github.com/minio/minio) Object Storage Server. You can use this release to deploy MinIO in standalone, single-node mode as well as in distributed mode on multiple nodes.

## Upload release
Upload MinIO release to the bosh director.

```
bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease
```

## Deploy

### Standalone Minio deployment

``` shell
$ bosh deploy -d minio manifests/manifest-fs-example.yml \
    -v minio_deployment_name=minio \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```

### Distributed MinIO deployment

For deploying a distributed version, set the number of desired instances in the manifest file.

``` shell
$ bosh deploy -d minio manifests/manifest-dist-example.yml \
    -v minio_deployment_name=minio \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```

### NAS MinIO deployment

For deploying a minio backed by a NAS mounted directory.  In this example using NFS with the nfs_mounter job from the capi release.

``` shell
$ bosh deploy -d minio manifests/manifest-nas-example.yml \
    -v minio_deployment_name=minio \
    -v minio_accesskey=admin \
    -v minio_secretkey=CHANGEME!
```

### PCF Tiles
* [MinIO Internal Blobstore for PCF](https://network.pivotal.io/products/minio-internal-blobstore/)

  Minio Internal Blobstore for PCF is a distributed S3 compatible blobstore for Pivotal Application Service (PAS). Operators can use Minio as blobstore for PAS instead of the internal WebDAV/NFS, which are single points of failure.

* [MinIO for PCF](https://network.pivotal.io/products/minio/)

  `MinIO for PCF` provides on-demand dedicated MinIO instances for PCF developers. The tile uses on-demand-service-broker API for provisioning of MinIO instances.

### License
MinIO BOSH release is licensed under [GNU AFFERO GENERAL PUBLIC LICENSE](https://www.gnu.org/licenses/agpl-3.0.en.html) 3.0 or later.

### Commercial License and Support
For commercial license and support, please contact pivotal@min.io.
