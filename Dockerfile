ARG BASE_IMAGE="debian:bullseye"
FROM ${BASE_IMAGE}
LABEL maintainer="akai"
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"
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
# Delete existing keys if present
RUN rm -f /etc/ssh/ssh_host_*

# Regenerate keys on each build
RUN ssh-keygen -A

# Fix permissions 
RUN chmod 700 /etc/ssh && chmod 600 /etc/ssh/ssh_host_*
COPY entry.sh /root/
ENTRYPOINT ["/root/entry.sh"]