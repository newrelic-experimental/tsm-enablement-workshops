FROM --platform=linux/amd64 debian:bookworm-slim

ARG USERNAME=demouser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo jq wget unzip htop curl procps findutils uuid-runtime ca-certificates gnupg \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash - 

RUN apt-get install -y nodejs

RUN curl -s https://cli.nr-ext.net/installer.sh | sudo bash

RUN export PATH="/usr/local/bin:$PATH" && echo 'export PATH="/usr/local/bin:$PATH"' >> /root/.bashrc

USER $USERNAME

SHELL [ "/bin/bash", "-c" ]

ENV SHELL=/bin/bash