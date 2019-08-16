FROM appcontainers/centos:6
MAINTAINER Rowell Belen "rowell.belen@bytekast.com"

ARG TARGET=x86_64-unknown-linux-gnu
ENV TARGET=${TARGET}
ENV RUST_ARCHIVE=rust-1.37.0-x86_64-unknown-linux-gnu.tar.gz
ENV RUST_DOWNLOAD_URL=https://static.rust-lang.org/dist/$RUST_ARCHIVE

RUN mkdir /rust
WORKDIR /rust

RUN curl -fsOSL $RUST_DOWNLOAD_URL \
    && curl -s $RUST_DOWNLOAD_URL.sha256 | sha256sum -c - \
    && tar -C /rust -xzf $RUST_ARCHIVE --strip-components=1 \
    && rm $RUST_ARCHIVE \
    && ./install.sh


RUN mkdir /cli
WORKDIR /cli
COPY Cargo.toml Cargo.lock build.rs ci/run.sh ./
COPY src ./src

RUN /cli/run.sh