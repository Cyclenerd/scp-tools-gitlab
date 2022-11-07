# SAP Cloud Platform (SAP BTP) Tools optimized for GitLab Runner

![Bagde: SAP](https://img.shields.io/badge/SAP-0FAAFF?logo=sap&logoColor=white)
![Badge: GitLab](https://img.shields.io/badge/GitLab-FC6D26.svg?logo=gitlab&logoColor=white)
![Bagde: Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?logo=docker&logoColor=white)
[![Bagde: Docker image](https://github.com/Cyclenerd/scp-tools-gitlab/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/Cyclenerd/scp-tools-gitlab/actions/workflows/docker-latest.yml)
[![Bagde: Docker pulls](https://img.shields.io/docker/pulls/cyclenerd/scp-tools-gitlab)](https://hub.docker.com/r/cyclenerd/scp-tools-gitlab)
[![Bagde: GitHub](https://img.shields.io/github/license/cyclenerd/scp-tools-gitlab)](https://github.com/Cyclenerd/scp-tools-gitlab/blob/master/LICENSE)

> 💿 One image to rule them all

This [Docker Image](https://hub.docker.com/r/cyclenerd/scp-tools-gitlab) is heavily used within the [Otto Group](https://www.ottogroup.com/).
More details in the SAP Blog post: <https://blogs.sap.com/2019/11/08/otto-group-its-journey-to-sap-cloud-platform/>



## Software

This [Docker image](https://hub.docker.com/r/cyclenerd/scp-tools-gitlab) based is on **Ubuntu GNU/Linux** 20.04 LTS (`ubuntu:20.04`).

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
    * [ui5-toolkit-gulp](https://www.npmjs.com/package/ui5-toolkit-gulp)
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

## CI/CD Example

### mta.yml

```
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

### .gitlab-ci.yml

SAP Cloud MTA Build Tool:

```
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

## Help 👍

If you have found a bug (English is not my mother tongue) or have any improvements, send me a pull request.
