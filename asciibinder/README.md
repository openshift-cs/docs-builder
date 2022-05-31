# Running the asciibinder container build locally

You can use the asciibinder container to build local asciidoc content without
installing asciibinder directly. To build your local asciidoc content, run the
following command from the asciidoc source folder:

```
podman run --rm -it -v `pwd`:/docs:Z quay.io/openshift-cs/docs-builder/asciibinder asciibinder build
```
