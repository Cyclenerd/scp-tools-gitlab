# SAP Cloud Platform Tools optimized for GitLab Runner

> One image to rule them all

This Docker Image is heavily used within the [Otto Group](https://www.ottogroup.com/).
More details in the SAP Blog post: <https://blogs.sap.com/2019/11/08/otto-group-its-journey-to-sap-cloud-platform/>

## Software

This Docker image based is on **Ubuntu GNU/Linux**.

The following software is included:

* [SapMachine](https://sap.github.io/SapMachine/) *OpenJDK release maintained and supported by SAP* (`java`)
* [Python](https://www.python.org/) 2 and 3 (`python3`)
* [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/) (`cf`)
* [SAP Cloud Platform Neo Environment SDK](https://tools.hana.ondemand.com/#cloud) (`neo.sh`)
* [SAP Multi-Target Application Archive Builder](https://help.sap.com/viewer/58746c584026430a890170ac4d87d03b/Cloud/en-US/ba7dd5a47b7a4858a652d15f9673c28d.html) (`mta_archive_builder.jar`)
  * Note: As of version 1.1.20, the Multi-Target Application Archive Builder is deprecated. Please use "SAP Cloud MTA Build Tool".
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
* Python 2: `python2`
* Python 3: `python3`
* Cloud Foundry CLI: `cf`
* SAP Cloud Platform Neo Environment SDK: `neo.sh`
* SAP Multi-Target Application Archive Builder: `java -jar $MTA_BUILDER_HOME/mta_archive_builder.jar`
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

SAP Multi-Target Application Archive Builder:

```
image: cyclenerd/scp-tools-gitlab:latest

stages:
  - deploy

build-and-deploy:
  stage: deploy
  script:
    - export VERSION=$(git rev-parse --short HEAD)
    - envsubst < mta.yaml > mta.yaml
    - java -jar $MTA_BUILDER_HOME/mta_archive_builder.jar --mtar deploy.mtar --build-target=NEO build
    - neo.sh deploy-mta -a "$SCP_ACCOUNT" -u "$SCP_USER" -p "$SCP_PASSWORD" -h hana.ondemand.com --source deploy.mtar --synchronous
  only:
    - master
```

## Help 👍

If you have found a bug (English is not my mother tongue) or have any improvements, send me a pull request.
