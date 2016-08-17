clang-tidy docker images for Mesos
==================================

This repository contains docker images in order to run clang-tidy
checks over a Mesos repository. It uses a [version of
clang-tidy](https://github.com/mesos/clang-tools-extra/tree/mesos_38)
augmented with Mesos-specific checks.


Building the docker images
--------------------------

We use two docker images to perform the checks, one containing
clang-tidy, and second one containing tooling to extract a clang
compilation database and invoke `clang-tidy` on all Mesos source files
which are part of the build. The images are Debian-based and use GCC
to perform the build.

The clang-tidy image can be built with

    $ docker build -t mesos/clang-tidy -f clang-tidy.Dockerfile .

For the Mesos-tidy use

    $ docker build -t mesos/tidy -f mesos-tidy.Dockerfile .


Running checks
--------------

To run checks over a Mesos checkout invoke

    $ docker run \
        -v <MESOS_CHECKOUT>:/SRC \
        -v <RESULT_DIR>:/OUT \
        [-e CHECKS=<CHECKS>] \
        [-e CONFIGURE_FLAGS=<CONFIGURE_FLAGS>] \
        --rm \
        mesos-tidy

Here `MESOS_CHECKOUT` points to a git checkout of the Mesos source
tree, and `RESULT_DIR` is directory to store result.

Additional configure parameters can be passed to the `./configure`
invocation for Mesos'. By default, `./configure` will be invoked
without arguments.

Optionally, the set of checks to perform can be specified in a
clang-tidy check regex. By default, only Mesos-specific checks will be
performed, i.e., the default value for `CHECKS` is `-*,mesos-*`.
