FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /opt && mkdir -p /home/gcc-user && useradd gcc-user && chown gcc-user /opt /home/gcc-user

RUN apt-get clean -y && apt-get check -y

RUN apt-get update -y -q && apt-get upgrade -y -q && apt-get upgrade -y -q && \
    apt-get install -y -q \
    autoconf \
    automake \
    libtool \
    bison \
    bzip2 \
    flex \
    curl \
    help2man \
    file \
    git \
    binutils-multiarch \
    libncurses5-dev \
    libtool-bin \
    linux-libc-dev \
    libc6-dev-i386 \
    make \
    ninja-build \
    s3cmd \
    sed \
    subversion \
    texinfo \
    wget \
    unzip \
    autopoint \
    gettext \
    zlib1g-dev \
    xz-utils \
    gcc \
    cmake \
    build-essential \
    aptitude \
    libstdc++6 \
    python3 \
    gawk \
    python-dev-is-python3

WORKDIR /opt

USER gcc-user
RUN wget -O - https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-1.26.0/crosstool-ng-1.26.0.tar.xz | tar -xJ 
WORKDIR /opt/crosstool-ng-1.26.0
RUN ./bootstrap && \
    mkdir build && cd build && \
    ../configure && \
    make -j$(($(nproc) * 2))
USER root
RUN cd build && make install && \
    cd .. && rm -rf build
WORKDIR /opt/
RUN rm -r crosstool-ng-1.26.0

USER gcc-user
RUN ct-ng aarch64-unknown-linux-gnu
RUN ls -la /home/gcc-user

RUN ct-ng build
ENV PATH=/home/gcc-user/x-tools/aarch64-unknown-linux-gnu/bin:$PATH


CMD ["/bin/bash"]
