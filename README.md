# Docs Builder

[![Docker Repository on Quay](https://quay.io/repository/openshift-cs/docs-builder/status "Docker Repository on Quay")](https://quay.io/repository/openshift-cs/docs-builder)

Provides the build pipeline necessary for building and serving the
OpenShift documentation at docs.openshift.com and docs.okd.io.

## Deployment

```
$ oc new-app template.yaml
```

### Deployment Parameters

#### docs.openshift.com

```
$ oc new-app template.yaml \
    -p NAME=docs-openshift-com \
    -p PACKAGE=commercial \
    -p APPLICATION_DOMAIN=docs.openshift.com \
    -p BUILD_REPO=https://github.com/openshift/openshift-docs.git \
    -p BUILD_BRANCH=main
```


#### docs.okd.io

```
$ oc new-app template.yaml \
    -p NAME=docs-okd-io \
    -p PACKAGE=community \
    -p APPLICATION_DOMAIN=docs.okd.io \
    -p BUILD_REPO=https://github.com/openshift/openshift-docs.git \
    -p BUILD_BRANCH=main \
    -p READINESS_DELAY=90
```
