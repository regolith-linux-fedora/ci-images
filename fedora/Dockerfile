ARG REFERENCE=${REFERENCE:-fedora:latest}
FROM $REFERENCE

ARG PACKAGES=${PACKAGES:-sudo}
RUN dnf -y --setopt=install_weak_deps=False install $PACKAGES && \
    dnf clean all

RUN useradd -m -u 1001 regolith && \
    usermod -aG wheel regolith && \
    if getent group mock >/dev/null; then usermod -aG mock regolith; fi && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/regolith/.ssh/ && \
    chown -R regolith /home/regolith/.ssh/ && \
    chmod 700 /home/regolith/.ssh

RUN mkdir -p /home/regolith/.gnupg/ && \
    chown -R regolith /home/regolith/.gnupg/ && \
    chmod 700 /home/regolith/.gnupg

RUN mkdir -p /build/ && \
    mkdir -p /build/buildlog/ && \
    mkdir -p /build/manifests/ && \
    mkdir -p /build/publish/ && \
    mkdir -p /build/workspace/ && \
    chown -R regolith /build/

SHELL ["/bin/bash", "--noprofile", "--norc", "-e", "-o", "pipefail", "-c"]

USER regolith
WORKDIR /build
