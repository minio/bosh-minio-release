#!/bin/bash

# Minio Cloud Storage, (C) 2018 Minio, Inc.
# This tool is used to create Minio BOSH Release.
# This tool should be run after a new release is 
# available at https://dl.minio.io/server/minio/release/linux-amd64/minio
# The script needs https://hub.github.com/ to be installed

gitrepo=`git remote get-url origin`
if [ $? -ne 0 ]
then
    echo "git remote get-url origin failed with status $?"
    exit $?
fi

if [ $gitrepo != "git@github.com:minio/minio-boshrelease.git" ]
then
    echo "Current git repo is not git@github.com:minio/minio-boshrelease.git"
    exit $?
fi

git diff-index --name-status --exit-code HEAD
if [ $? -ne 0 ]
then
    echo "The repo has uncommitted files, exiting."
    exit $?
fi

git checkout master
if [ $? -ne 0 ]
then
    echo "git checkout master failed with status $?"
    exit $?
fi

git pull
if [ $? -ne 0 ]
then
    echo "git pull failed with status $?"
    exit $?
fi

echo "Downloading latest minio to /tmp/minio"
wget --quiet -O /tmp/minio https://dl.minio.io/server/minio/release/linux-amd64/minio
if [ $? -ne 0 ]
then
    echo wget exited with status $?
    exit $?
fi

shaGot=`sha256sum /tmp/minio | awk -F' ' '{print $1}'`
curlOutput=`curl -s https://dl.minio.io/server/minio/release/linux-amd64/minio.sha256sum`

shaExpected=`echo $curlOutput | awk -F' ' '{print $1}'`
version=`echo $curlOutput | awk -F' ' '{print $2}'| awk -F'.' '{print $3}'`

if [ $shaGot != $shaExpected ]
then
    echo "SHA256 mismatch on the downloaded minio binary"
    exit 1
fi

versionLength=`echo $version | wc -m`
if [ $versionLength != "21" ]
then
    echo "Version $version is incorrect"
    exit 1
fi

git checkout -b $version
if [ $? -ne 0 ]
then
    echo "git checkout -b $version failed with status $?"
    exit $?
fi

echo "Executing: bosh2 add-blob --sha2 /tmp/minio minio"
bosh2 add-blob --sha2 /tmp/minio minio
if [ $? -ne 0 ]
then
    echo "bosh2 add-blob failed with status $?"
    exit $?
fi

echo "Executing: bosh2 create-release --sha2 --version=$version --final --force"
bosh2 create-release --sha2 --version=$version --final --force
if [ $? -ne 0 ]
then
    echo "bosh2 create-release failed with status $?"
    exit $?
fi

git add .final_builds/packages/minio/index.yml config/blobs.yml releases/minio/index.yml releases/minio/minio-$version.yml
if [ $? -ne 0 ]
then
    echo "git add failed with status $?"
    exit $?
fi

git commit -m "Minio BOSH release $version"
if [ $? -ne 0 ]
then
    echo "git commit failed with status $?"
    exit $?
fi

echo "Executing: git push"
git push origin $version
if [ $? -ne 0 ]
then
    echo "git push failed with status $?"
    exit $?
fi

# https://hub.github.com/ needs to be installed for the following command to work.
hub pull-request -m "Minio BOSH release $version"
if [ $? -ne 0 ]
then
    echo "git pull-request failed with status $?"
    exit $?
fi
