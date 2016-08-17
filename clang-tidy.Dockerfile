# Build as
#
#     $ docker build -t mesos/clang-tidy -f clang-tidy.Dockerfile .

FROM debian:jessie
MAINTAINER The Apache Mesos Developers <dev@mesos.apache.org>

# Install LLVM dependencies.
RUN apt-get update
RUN apt-get install -qy --no-install-recommends \
  build-essential \
  cmake \
  git \
  ninja-build \
  python-dev &&\
  apt-get clean

WORKDIR /tmp/build_clang

RUN git clone --depth 1 -b release_38 http://llvm.org/git/llvm /tmp/llvm
RUN git clone --depth 1 -b release_38 http://llvm.org/git/clang /tmp/llvm/tools/clang

RUN git config --global http.sslVerify false
RUN git clone --depth 1 -b mesos_38   http://github.com/mesos/clang-tools-extra.git /tmp/llvm/tools/clang/tools/extra
RUN rm ~/.gitconfig

RUN cmake /tmp/llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/
RUN make install

WORKDIR /
RUN rm -rf /tmp/llvm
RUN rm -rf /tmp/build_clang

ENV PATH /opt/bin:$PATH
