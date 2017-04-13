# BOSH Minio Release

[BOSH](http://bosh.io/) allows users to easily version, package and deploy software in a reproducible manner. This repo provides BOSH release of [Minio](https://github.com/minio/minio) Object Storage Server. You can use this release to deploy Minio in standalone, single-node mode as well as in distributed mode on multiple nodes.

To get started from scratch with the BOSH Minio release locally, you can follow the steps below starting with installing `bosh-lite`. If you already have a BOSH installation available, you can jump straight to the [Create and upload BOSH release section](#create).

## Install `bosh-lite` and `bosh_cli`

- bosh-lite installation [instructions](https://github.com/cloudfoundry/bosh-lite/blob/master/README.md). 
- bosh_cli installation [instructions](http://bosh.io/docs/bosh-cli.html).

## Upload stemcell to BOSH

Stemcell is a versioned Operating System image wrapped with IaaS specific packaging. You'll need to provide the bosh-lite Warden stemcell. You can download it from 
[here](https://s3.amazonaws.com/bosh-core-stemcells/warden/bosh-stemcell-3363.12-warden-boshlite-ubuntu-trusty-go_agent.tgz).

Once downloaded, use the command below to upload it to your VM:

``` shell
bosh upload stemcell ~/Downloads/bosh-stemcell-3363.12-warden-boshlite-ubuntu-trusty-go_agent.tgz --skip-if-exists
```
<a name="create"></a>
## Create and upload the BOSH release

``` shell
bosh create release --force
    Please enter development release name: minio
bosh upload release
```

## Create manifest from examples files in `manifests`

Copy a manifest from the [`manifests/`](https://github.com/minio/minio-boshrelease/tree/master/manifests) directory and replace the
`director_uuid` field with the one from your BOSH director.

The UUID to put in the manifest can be found with:

``` shell
bosh status
```

## Deploy

### Standalone Minio deployment

Set the deployment manifest by providing the name of your manifest, for example:

``` shell
bosh deployment manifest/manifest-fs.yml
```

Then run the deploy command:

``` shell
bosh deploy
```

With the default settings (in [example manifest](https://github.com/minio/minio-boshrelease/blob/master/manifests/manifest-fs.yml)), you should be able to access the minio server at `http://10.244.0.2:9001`. 

Test with the [mc](https://github.com/minio/mc) tool:

``` shell
###### Using settings in the example manifest ######
mc config host add boshminio http://10.244.0.2:9001 minio minio123
# Test it out:
mc ls boshminio
mc mb boshminio/bucket
mc cp /etc/issue boshminio/bucket/
```

### Distributed Minio deployment

For deploying a distributed version, set the number of desired instances in the manifest file along with that many `static_ips` in
the `jobs` section of the manifest, as shown in the [example manifest](https://github.com/minio/minio-boshrelease/blob/master/manifests/manifest-dist-4node.yml).

With the default settings (in [example manifest](https://github.com/minio/minio-boshrelease/blob/master/manifests/manifest-dist-4node.yml)), you can test the deployment with mc as follows:

``` shell
mc config host add boshminio1 http://10.244.0.2:9001 minio minio123
mc config host add boshminio2 http://10.244.0.3:9001 minio minio123
mc config host add boshminio3 http://10.244.0.4:9001 minio minio123
mc config host add boshminio4 http://10.244.0.5:9001 minio minio123

mc mb boshminio1/bucket # Create a bucket
mc ls boshminio{1..4} # List all the 4 minio endpoints. Should see the
                      # bucket printed four times.
```
