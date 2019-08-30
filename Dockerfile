FROM fedora:30

LABEL maintainer="yee.yi@vesoft.com"

RUN yum update && yum -y install git \
  autoconf \
  automake \
  libtool \
  cmake \
  bison \
  unzip \
  boost \
  gperf \
  krb5 \
  openssl \
  libunwind \
  ncurses \
  readline \
  maven \
  java-1.8.0-openjdk \
  && sh -c "$(wget https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh -O -)" \
  && yum install -y git-lfs \
  && git lfs install \
  && yum clean all \
  && rm -rf /var/cache/yum

RUN mkdir -p /home/nebula \
  && git clone https://github.com/vesoft-inc/nebula-3rdparty.git \
  && cd nebula-3rdparty \
  && cmake . && make && make install \
  && pushd && cd third-party/fbthrift/thrift/lib/java/thrift \
  && mvn compile install \
  && popd && cd .. && rm -rf nebula-3rdparty

WORKDIR /home/nebula