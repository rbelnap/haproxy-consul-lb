FROM haproxy:alpine

ENV CONSUL_TEMPLATE_VERSION=0.16.0

# cribbed from https://github.com/anthcourtney/docker-consul-template-haproxy/blob/master/haproxy/Dockerfile
RUN apk --update add haproxy wget

# install and setup consul-template


# TODO do this validly with certs
RUN ( wget --no-check-certificate https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -O /tmp/consul_template.zip && unzip /tmp/consul_template.zip && mv consul-template /usr/bin && rm -rf /tmp/* )

COPY files/haproxy.json /tmp/haproxy.json
COPY files/haproxy.ctmpl /tmp/haproxy.ctmpl

ENTRYPOINT ["consul-template","-config=/tmp/haproxy.json"]
CMD ["-consul=consul:8500"]




