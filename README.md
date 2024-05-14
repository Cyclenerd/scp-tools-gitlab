# SAP Cloud (SAP BTP) Tools optimized for GitLab Runner

[![Badge: SAP](https://img.shields.io/badge/SAP-0FAAFF?logo=sap&logoColor=white)](#readme)
[![Badge: GitLab](https://img.shields.io/badge/GitLab-FC6D26.svg?logo=gitlab&logoColor=white)](#readme)
[![Badge: Ubuntu](https://img.shields.io/badge/Ubuntu-E95420.svg?logo=ubuntu&logoColor=white)](#readme)
[![Badge: Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?logo=docker&logoColor=white)](#readme)
[![Badge: License](https://img.shields.io/github/license/cyclenerd/scp-tools-gitlab)](https://github.com/Cyclenerd/scp-tools-gitlab/blob/master/LICENSE)

---

## Public Archive Notice

This repository has been transitioned to a public archive.
While development has ceased, the codebase remains available for reference and historical purposes.

**Impact on Current Users:**

* New features and bug fixes will no longer be implemented.
* Issues and pull requests will not be reviewed or merged.
* This container image will be delisted from Docker Hub in August 2024. Please make alternative arrangements before then.

**Accessing the Codebase:**

* You can continue to clone, fork, and explore the code at your convenience.
* The codebase reflects the repository's state at the time of archiving.

**Staying Informed:**

* I recommend considering alternative projects that are actively maintained for your ongoing development needs.

**Contributing:**

* While new contributions are no longer accepted in this repository, feel free to explore forking the codebase and creating your own derivative project.

**Thank You:**

I appreciate your past contributions and interest in this project.
I hope the archived codebase remains a valuable resource!

---

> 💿 One image to rule them all

This Docker container image <s>is</s> was heavily used within the [Otto Group](https://www.ottogroup.com/).
More details in the SAP Blog post: <https://community.sap.com/t5/technology-blogs-by-members/otto-group-it-s-journey-to-sap-cloud-platform/ba-p/13437042>

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
