# SAP Cloud Platform Tools optimized for GitLab Runner

> One image to rule them all

This Docker Image is heavily used within the [Otto Group](https://www.ottogroup.com/).
More details in the SAP Blog post: <https://blogs.sap.com/2019/11/08/otto-group-its-journey-to-sap-cloud-platform/>

## Software

This Docker image based is on **Ubuntu GNU/Linux** 20.04 LTS (`ubuntu:latest`).

The following software is included:

* [SapMachine](https://sap.github.io/SapMachine/) *OpenJDK release maintained and supported by SAP* (`java`)
* [Python 3](https://www.python.org/) (`python3`)
* [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/) (`cf`)
* [SAP Cloud Platform Neo Environment SDK](https://tools.hana.ondemand.com/#cloud) (`neo.sh`)
* [SAP Cloud MTA Build Tool](https://sap.github.io/cloud-mta-build-tool/) (`mbt`)
* [Node.js](https://nodejs.org/) (`node`)
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

Execute...

* Java: `java`
* Python 3: `python3`
* Cloud Foundry CLI: `cf`
* SAP Cloud Platform Neo Environment SDK: `neo.sh`
* Node.js: `node`
* SAP Cloud MTA Build tool: `mbt`
* MkDocs: `mkdocs`

### Example

#### mta.yml

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

#### .gitlab-ci.yml

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
