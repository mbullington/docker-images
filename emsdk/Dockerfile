FROM emscripten/emsdk:latest

ENV EMSCRIPTEN_VERSION 2.0.14

RUN apt-get -qq update \
  && apt-get install -y -qq --no-install-recommends ninja-build \
  && apt-get -y --purge remove openjdk-11-jre-headless git curl cmake build-essential \
  && apt-get -y clean \
  && apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/debconf/*-old \
  && rm -rf /usr/share/doc/* \
  && rm -rf /usr/share/man/?? \
  && rm -rf /usr/share/man/??_* \
  && echo "## Done"

SHELL ["/bin/bash", "-c"]

VOLUME /src
WORKDIR /src
