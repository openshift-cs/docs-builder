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

This image also supports running `watch` for continuously updated output pages:

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder asciibinder watch
```

Hit `q` to quit the watch process in the terminal.

    **Note:** Open the preview HTML at the page you are editing and if you don't see the change, hit F5. `watch` adds lots of noise and sometimes errors in the terminal. For the most part, you can ignore these. The tool is temperamental - YMMV. 

# Running the openshift-docs build image

The `quay.io/openshift-cs/openshift-docs-build` contains asciibinder, and a preinstalled python env to run the `makeBuild.py` and `build_for_portal.py` that you use to test and deploy asciibinder-built HTML to the customer portal.

From the root of the openshift-docs repo, run the following, or similar:

```
$ podman run --rm -it -v `pwd`:/openshift-docs-build:Z quay.io/openshift-cs/openshift-docs-build python3 build_for_portal.py --distro openshift-enterprise --product "OpenShift Container Platform" --version 4.13 --no-upstream-fetch && python3 makeBuild.py
```

# Multi-architecture Image

## Use

Pull from the `:multiarch` tag

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/asciibinder:multiarch asciibinder build
```

or

```
$ podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/openshift-docs-build:multiarch python3 build_for_portal.py --distro openshift-enterprise --product "OpenShift Container Platform" --version 4.13 --no-upstream-fetch && python3 makeBuild.py
```


## Building

```
$ git clone https://github.com/openshift-cs/docs-builder.git
$ cd docs-builder/asciibinder
$ docker buildx build --push --platform linux/amd64,linux/arm64 --tag quay.io/openshift-cs/asciibinder:multiarch -f asciibinder.Dockerfile .
$ docker buildx build --push --platform linux/amd64,linux/arm64 --tag quay.io/openshift-cs/openshift-docs-build:multiarch -f openshift-docs-build.Dockerfile .
```
