# Running the asciibinder container build locally

You can use the asciibinder container to build local asciidoc content without
installing asciibinder directly. To build your local asciidoc content, run one of the
following commands from the asciidoc source folder:

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder asciibinder build
```

To build a specific distro, for example, `openshift-enterprise` run:

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder asciibinder build -d openshift-enterprise
```

This image also supports running `watch` for continuously updated output pages

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder asciibinder watch
```

# Multi-architecture Image

## Use

Pull from the `:multiarch` tag

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder:multiarch asciibinder build
```

## Building

```
$ git clone https://github.com/openshift-cs/docs-builder.git
$ cd docs-builder/asciibinder
$ docker buildx build --push --platform linux/amd64,linux/arm64 --tag quay.io/openshift-cs/asciibinder:multiarch .
```
