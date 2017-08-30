FROM alpine:3.6

RUN apk add --no-cache curl python2 py2-pip

# Install Consul
ENV CONSUL_VERSION 0.7.3
ENV CONSUL_CHECKSUM 901a3796b645c3ce3853d5160080217a10ad8d9bd8356d0b73fcd6bc078b7f82
RUN curl --retry 3 -Lso /tmp/consul.zip \
    "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
RUN echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" > /tmp/consul.sha256 \
    && sha256sum -c /tmp/consul.sha256 \
    && unzip /tmp/consul -d /bin \
    && rm /tmp/consul.zip

# Install Consul Template
ENV CONSUL_TEMPLATE_VERSION 0.15.0
ENV CONSUL_TEMPLATE_CHECKSUM b7561158d2074c3c68ff62ae6fc1eafe8db250894043382fb31f0c78150c513a
RUN curl --retry 3 -Lso /tmp/consul-template.zip \
    "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" \
    && unzip /tmp/consul-template.zip -d /bin \
    && rm /tmp/consul-template.zip

# Install s6 overlay
ENV S6_OVERLAY_VERSION 1.18.1.5
RUN curl -Ls "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" | tar xvzf - -C /

EXPOSE 8301 8301/udp
ENTRYPOINT [ "/init" ]
