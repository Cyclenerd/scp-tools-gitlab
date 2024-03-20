# SAP Cloud (SAP BTP) Tools optimized for GitLab Runner

[![Badge: SAP](https://img.shields.io/badge/SAP-0FAAFF?logo=sap&logoColor=white)](#readme)
[![Badge: GitLab](https://img.shields.io/badge/GitLab-FC6D26.svg?logo=gitlab&logoColor=white)](#readme)
[![Badge: Ubuntu](https://img.shields.io/badge/Ubuntu-E95420.svg?logo=ubuntu&logoColor=white)](#readme)
[![Badge: Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?logo=docker&logoColor=white)](#readme)
[![Badge: Docker image](https://github.com/Cyclenerd/scp-tools-gitlab/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/Cyclenerd/scp-tools-gitlab/actions/workflows/docker-latest.yml)
[![Badge: License](https://img.shields.io/github/license/cyclenerd/scp-tools-gitlab)](https://github.com/Cyclenerd/scp-tools-gitlab/blob/master/LICENSE)
[![Badge: Docker pulls](https://img.shields.io/docker/pulls/cyclenerd/scp-tools-gitlab)](https://hub.docker.com/r/cyclenerd/scp-tools-gitlab)

> 💿 One image to rule them all

This [Docker container image](https://hub.docker.com/r/cyclenerd/scp-tools-gitlab) is heavily used within the [Otto Group](https://www.ottogroup.com/).
More details in the SAP Blog post: <https://blogs.sap.com/2019/11/08/otto-group-its-journey-to-sap-cloud-platform/>

## Software

Container image based is on **Ubuntu GNU/Linux**.

The following software is included:

* [SapMachine](https://sap.github.io/SapMachine/) *OpenJDK release maintained and supported by SAP* (`java`)
* [Python 3](https://www.python.org/) (`python3`)
* [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/) (`cf`)
* [SAP Cloud Platform Neo Environment SDK](https://tools.hana.ondemand.com/#cloud) (`neo.sh`)
* [SAP Cloud MTA Build Tool](https://sap.github.io/cloud-mta-build-tool/) (`mbt`)
* [Node.js](https://nodejs.org/) (`node`)
  * [@ui5/cli](https://www.npmjs.com/package/@ui5/cli)
  * [grunt-cli](https://www.npmjs.com/package/grunt-cli)
  * [gulp-cli](https://www.npmjs.com/package/gulp-cli)
    * <s>[ui5-toolkit-gulp](https://www.npmjs.com/package/ui5-toolkit-gulp)</s> (removed)
  * [showdown](https://www.npmjs.com/package/showdown)
  * [eslint](https://www.npmjs.com/package/eslint)
    * [eslint-plugin-ui5](https://www.npmjs.com/package/eslint-plugin-ui5)
    * [eslint-config-ui5](https://www.npmjs.com/package/eslint-config-ui5)
* [MkDocs](https://www.mkdocs.org/) (`mkdocs`)
  * [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)

## HOWTO

Docker pull command:
```shell
docker pull cyclenerd/scp-tools-gitlab:latest
```

Execute...

* Java: `java`
* Python 3: `python3`
* Cloud Foundry CLI: `cf`
* SAP Cloud Platform Neo Environment SDK: `neo.sh`
* Node.js: `node`
* SAP Cloud MTA Build tool: `mbt`
* MkDocs: `mkdocs`

Example run command:
```
docker run cyclenerd/scp-tools-gitlab:latest java --version
```

## Examples

### MTA (`mta.yml`)

```yml
_schema-version: '2.0'
ID: de.nkn-it.demo
version: 1.0.0

modules:
  - name: demo
    type: html5
    path: webapp
    parameters:
      version: ${VERSION}
    build-parameters:
      builder: zip
      ignore: ["*.git*"]
```

### GitLab CI (`.gitlab-ci.yml`)

```yml
image: cyclenerd/scp-tools-gitlab:latest

stages:
  - deploy

build-and-deploy:
  stage: deploy
  script:
    - export VERSION=$(git rev-parse --short HEAD)
    - envsubst < mta.yaml > mta.yaml
    - mbt build --platform=neo --target=mta_archives --mtar=deploy.mtar
    - neo.sh deploy-mta -a "$SCP_ACCOUNT" -u "$SCP_USER" -p "$SCP_PASSWORD" -h hana.ondemand.com --source mta_archives/deploy.mtar --synchronous
  only:
    - master
```

### Google Cloud Build (`cloudbuild.yml`)

```yml
 - name: 'cyclenerd/scp-tools-gitlab:latest'
   entrypoint: 'java'
   args: ['--version']
```

## Help 👍

If you have found a bug (English is not my mother tongue) or have any improvements, send me a pull request.
