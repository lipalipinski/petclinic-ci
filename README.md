# Petclinic-CI

This repo is a part of Intro to DevOps final project. It's main purpose is to separate CI/CD related files from app repo.

Jenkins pipelines are designed to be used with [Remote Jenkinsfile Provider](https://plugins.jenkins.io/remote-file/). Setet job's Branch Source to app respository, and provide this repo in Jenkinsfile SCM/Repository URL in Build Confiiguration (set mode to Remote Jenkinsfile Provider Plugin). This repository is being checkout into workdir if necessary in the checkout SCM step. Each pipeline sets custom build name like #[build no.] [VERSION].

### Required Jenkins plugins
- [Docker Pipeline](https://plugins.jenkins.io/docker-workflow/)
- [Nexus Artifact Uploader](https://plugins.jenkins.io/nexus-artifact-uploader/)
- [Pipeline Utility Steps](https://plugins.jenkins.io/pipeline-utility-steps/)
- [Remote Jenkinsfile Provider](https://plugins.jenkins.io/remote-file/)

### Jenkins credentials

These pipelines require following credentials set in Jenkins:
- 

## Jenkinsfile-PreCommit

> PreCommit job:
> - watch for changes being pushed to review to any branch;
> - build project with Maven, including unit tests (if any); this imitates linter work;
> - should NOT upload artifacts to Nexus.

## Jenkinsfile-Build

> Build job:
> - watch for updates on "dev" branch;
> - build project with Maven, including unit tests (if any);
> - on successful build:
>    * upload artifacts to Nexus (snapshots repository);
>    * build Docker image with snapshot artifact and upload it to DockerHub snapshot registry. 
>    * Tag image like: petclinic:artifact-version (e.g. petclinic:1.0.0-SNAPSHOT).

## Jenkinsfile-Promotion

Expects parameter VERSION (x.x.x-SNAPSHOT) specifying an artifact version to build. Promotes the newst artifact of specified version found on Nexus repo. 
Additionally, pipeline is checking an artifact with SHA1 checksum.

>Promotion job:
> - triggered manually;
> - takes artifact version as an input parameter; 
> - downloads specified artifact version;
> - changes artifact version to release one;
> - uploads artifact(s) to Nexus (release repository);
> - Build Docker image with released artifact (pulls proper version from Nexus release repo). Tag it like: petclinic:release-artifact-version (e.g. petclinic:1.0.0) and push it to DockerHub release registry.
> - trigger deploy job(release version)


## Jenkinsfile-Deploy

> Deployment job:
> - can be triggered by the Promotion job or manually;
> - receives artifact version as a parameter;
> - runs Docker container on the slave instance. 
> - Make sure that you are able to open the PetClinic start page on 80 port.

## Dockerfile

A dockerfile to build a docker image with. Assumes a path to .jar file passed with $jarfile argument on build.

## mvn-settings.xml

Custom maven settings to use on app build. Needed for Nexus proxy, release and snapshot setup.

## scripts/check-site.sh

A script checking for app response on a port provided with $1 arg. By default it checks in 2s intervals and time-outs after 60s.