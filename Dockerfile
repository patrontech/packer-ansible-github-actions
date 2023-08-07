# see https://hub.docker.com/r/hashicorp/packer/tags for all available tags
FROM hashicorp/packer:light-1.8.7@sha256:1c6805930b95574e282d02ca5d39d5893453ffbd3ff2d433bd7040376671813e
ARG MITOGEN_VERSION=0.2.9
ARG ANSIBLE_VERSION=3.2.0
LABEL ansibleVersion=$ANSIBLE_VERSION

ARG ANSIBLE_LINT_VERSION=5.0.7
RUN apk --update --no-cache add \
    ca-certificates \
    git \
    openssh-client \
    openssl \
    python3\
    py3-pip \
    py3-cryptography \
    rsync \
    sshpass

RUN apk --update add --virtual \
    .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    curl \
    #    && curl -s -L https://networkgenomics.com/try/mitogen-${MITOGEN_VERSION}.tar.gz | tar xzf - -C /opt/ \
    #    && mv /opt/mitogen-* /opt/mitogen \
    && pip3 install --upgrade \
    pip \
    cffi \
    && pip3 install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION} \
    && apk del \
    .build-deps \
    && rm -rf /var/cache/apk/*

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]