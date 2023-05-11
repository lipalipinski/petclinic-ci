# Petclinic-CI

This repo is a part of Intro to DevOps final project. It's main purpose is to separate CI/CD related files from app repo.

Jenkins pipelines are designed to be used with [Remote Jenkinsfile Provider](https://plugins.jenkins.io/remote-file/). Main logic is to set Branch Source to app respository, and this repo in Jenkinsfile SCM/Repository URL in Build Confiiguration (with Mode set to Remote Jenkinsfile Provider Plugin) in Jenkins. This repository is being checkout into workdir if necessary in the checkout SCM step. 

## Jenkinsfile-PreCommit

PreCommit job:
- watch for changes being pushed to review to any branch;
- build project with Maven, including unit tests (if any); this imitates linter work;
- should NOT upload artifacts to Nexus.

## Jenkinsfile-Build

Build job:
- watch for updates on "dev" branch;
- build project with Maven, including unit tests (if any);
- on successful build:
    * upload artifacts to Nexus (snapshots repository);
    * build Docker image with snapshot artifact and upload it to DockerHub snapshot registry. 
    * Tag image like: petclinic:artifact-version (e.g. petclinic:1.0.0-SNAPSHOT).

## Jenkinsfile-Promotion

Promotion job:
- triggered manually;
- takes artifact version as an input parameter; 
- downloads specified artifact version;
- changes artifact version to release one;
- uploads artifact(s) to Nexus (release repository);
- Build Docker image with released artifact (pulls proper version from Nexus release repo). Tag it like: petclinic:release-artifact-version (e.g. petclinic:1.0.0) and push it to DockerHub release registry.
- trigger deploy job(release version)

