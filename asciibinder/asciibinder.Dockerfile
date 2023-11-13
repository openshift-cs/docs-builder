FROM ruby:3.1.2-alpine3.16 AS builder

RUN apk update && apk add --virtual build-dependencies build-base

RUN gem install listen asciidoctor asciidoctor-diagram ascii_binder

FROM ruby:3.1.2-alpine3.16

COPY --from=builder /usr/local/bundle /usr/local/bundle

RUN apk add --update --no-cache git bash

WORKDIR /docs

LABEL url="http://www.asciibinder.org" \
      summary="Asciibinder builder" \
      description="Run the asciibinder container image from the local docs repo, which is mounted into the container. Pass asciibinder commands to run the build. Generated files are owned by root." \
      RUN="podman run --rm -it -v `pwd`:/docs:Z IMAGE asciibinder build"
