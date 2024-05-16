FROM alpine:3.19

ENV REVIEWDOG_VERSION=v0.17.3
ENV TERRAFORM_VERSION=1.7.3

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apk --no-cache add git jq=1.7.1-r0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

RUN wget -q https://releases.hashicorp.com/terraform/"${TERRAFORM_VERSION}"/terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip \
    && unzip ./terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip -d /usr/local/bin/ \
    && rm -rf ./terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
