FROM buildkite/agent:alpine as base

FROM python:3.7-alpine3.10

ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache --update python3 \
    bash \
    git \
    perl \
    rsync \
    bind-tools \
    openssl \ 
    openssl-dev \
    openssh \
    openssh-client \
    curl \
    docker \
    jq \
    su-exec \
    libc6-compat \
    run-parts \
    tini \
    gcc \
    musl-dev \
    libffi-dev \
    linux-headers \
    ca-certificates \
    tzdata \
    zip \
    jq \
    gettext \
    npm \
    make && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    pip install --upgrade awscli awsebcli s3cmd \
    && rm -rf /var/cache/apk/*

ENV BUILDKITE_AGENT_CONFIG=/buildkite/buildkite-agent.cfg

RUN mkdir -p /buildkite/builds /buildkite/hooks /buildkite/plugins \
    && curl -Lfs -o /usr/local/bin/ssh-env-config.sh https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

COPY --from=base /buildkite/buildkite-agent.cfg /buildkite/buildkite-agent.cfg
COPY --from=base /usr/local/bin/buildkite-agent /usr/local/bin/buildkite-agent
COPY --from=base /usr/local/bin/buildkite-agent-entrypoint /usr/local/bin/buildkite-agent-entrypoint

VOLUME /buildkite
ENTRYPOINT ["buildkite-agent-entrypoint"]
CMD ["start"]