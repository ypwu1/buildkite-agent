FROM buildkite/agent:3.33-ubuntu as base

RUN apt-get update && apt-get install -y --no-install-recommends \ 
    unzip make \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf /aws awscliv2.zip \
    && curl https://cli-assets.heroku.com/install-ubuntu.sh | sh