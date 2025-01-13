# syntax=docker/dockerfile:1

## Buildstage ##
FROM rust:bookworm AS buildstage


ENV EXPORTER_VERSION=3.6.6


RUN apt update && apt install -y cargo git musl-dev \
&& apt clean \
&& git clone https://github.com/MindFlavor/prometheus_wireguard_exporter.git \
&& cd prometheus_wireguard_exporter \
&& git checkout tags/${EXPORTER_VERSION} \
&& cargo install --path . \
&& mkdir -p /root_level/usr/bin/ \
&& cp /usr/local/cargo/bin/prometheus_wireguard_exporter /root_level/usr/bin/

COPY root/ /root_level/

## Single layer deployed image ##
FROM scratch

LABEL maintainer="gjed"
LABEL org.opencontainers.image.source=https://github.com/gjed/wireguard-prometheus-exporter-mod

# Add files from buildstage
COPY --from=buildstage /root_level/ /