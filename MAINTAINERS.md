This file contains information for maintainers.

## How to update this release with a newer version of Minio using Bosh V2

### Fetch and verify new binary

The latest version of the Minio binary for amd64 Linux is available at
https://dl.minio.io/server/minio/release/linux-amd64/

Download it locally and verify the shasum. Rename the binary file to
just `minio`. Example commands:

``` shell
# For a current release:
wget -O /tmp/minio https://dl.minio.io/server/minio/release/linux-amd64/minio

# Then verify the sha256sum, like below (e.g. commands and output are below):
$ sha256sum /tmp/minio
b7707b11c64e04be87b4cf723cca5e776b7ed3737c0d6b16b8a3d72c8b183135  /tmp/minio
$ curl https://dl.minio.io/server/minio/release/linux-amd64/minio.sha256sum
b7707b11c64e04be87b4cf723cca5e776b7ed3737c0d6b16b8a3d72c8b183135 minio.RELEASE.2017-09-29T19-16-56Z
```

### Update blob for new package

``` shell
bosh2 add-blob --sha2 /tmp/minio minio
```

Create the final release and upload blobs. Example commands:

``` shell
bosh2 create-release --sha2 --version=2017-09-29T19-16-56Z --final --force
```

Commit the files generated to Git:
```
git add config/blobs.yml
git add releases/minio/index.yml
git add releases/minio/minio-2017-09-29T19-16-56Z.yml
git commit -m 'Minio BOSH release 2017-09-29T19-16-56Z'
```

All done, send a PR!

Create a Github TAG `RELEASE.2017-09-29T19-16-56Z`
Create a Github Release here https://github.com/minio/minio-boshrelease/releases

After a while new bosh release should automatically appear here:
https://bosh.io/releases/github.com/minio/minio-boshrelease

