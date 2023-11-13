FROM ruby:3.1.2-alpine3.16 AS builder

RUN apk update && apk add --virtual build-dependencies build-base

RUN gem install listen asciidoctor asciidoctor-diagram ascii_binder

FROM ruby:3.1.2-alpine3.16

COPY --from=builder /usr/local/bundle /usr/local/bundle

ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache git bash python3 python3-dev && ln -sf python3 /usr/bin/python

RUN python3 -m ensurepip

RUN pip3 install --no-cache --upgrade pip setuptools

WORKDIR /openshift-docs-build

COPY ./aura.tar.gz /openshift-docs-build

RUN pip3 install --no-cache-dir pyyaml aura.tar.gz

LABEL url="http://www.asciibinder.org" \
      summary="OpenShift Docs Build Tools" \
      description="Run the asciibinder or openshift python build image from the local docs repo, which is mounted into the container. Generated files are owned by root." \
      RUN='podman run --rm -it -v `pwd`:/openshift-docs-build:Z IMAGE python3 build_for_portal.py --distro openshift-enterprise --product "OpenShift Container Platform" --version 4.13 --no-upstream-fetch && python3 makeBuild.py'
