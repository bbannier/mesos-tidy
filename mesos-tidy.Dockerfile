# Build as
#
#     $ docker build -t mesos/tidy -f mesos-tidy.Dockerfile .

FROM mesos/clang-tidy:latest
MAINTAINER The Apache Mesos Developers <dev@mesos.apache.org>

# Install Mesos dependencies
RUN apt-get update
RUN apt-get install -qy \
  autoconf \
  bear \
  jq \
  libapr1-dev \
  libcurl4-nss-dev \
  libev-dev \
  libevent-dev \
  libsasl2-dev \
  libsasl2-modules \
  libsvn-dev \
  libtool \
  maven \
  openjdk-7-jdk \
  python-dev \
  zlib1g-dev && \
  apt-get clean

# Install parallel for clang-tidy invocation.
RUN apt-get install -qy \
  parallel

VOLUME ["/SRC"]

WORKDIR /BUILD
ADD ["entrypoint.sh", "entrypoint.sh"]
CMD exec ./entrypoint.sh
