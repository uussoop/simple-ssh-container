ARG BASE_IMAGE="debian:stable-slim"

FROM ${BASE_IMAGE}
LABEL maintainer="akai"

# Make sure we keep apt silent during installs
ENV DEBIAN_FRONTEND=noninteractive \
    PUID=9999 \
    PGID=9999 \
    SSH_USER="tunnel" \
    SSH_GROUP="tunnelgroup" \
    SSH_PORT="2222" \
    SSH_HOST_KEY_DIR="/etc/ssh/ssh_host_keys" \
    DEBUG_MODE="false" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# Install SSH server and ping command
RUN apt-get update \
    && echo "Install requirements..." \
    && apt-get -y --no-install-recommends install \
        openssh-server \
        iputils-ping \
        locales \
        locales-all \
    && echo "Create run directory..." \
    && mkdir /run/sshd \
    && echo "Clean up after ourselves..." \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Ensure generated keys are removed at this stage..." \
    && rm -rf /etc/ssh/ssh_host_*
COPY scripts/prep-ssh-server /root/
ENTRYPOINT ["/root/prep-ssh-server"]

# CMD ["/usr/sbin/sshd", "-D","-e"]