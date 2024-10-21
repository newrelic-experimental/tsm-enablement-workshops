FROM debian:bookworm-slim

ARG USERNAME=demouser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo jq wget unzip htop curl procps findutils uuid-runtime \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN curl --proto '=https' --tlsv1.2 -fOL https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.111.0/otelcol-contrib_0.111.0_linux_amd64.tar.gz && \
    tar -xvf otelcol-contrib_0.111.0_linux_amd64.tar.gz && \
    sudo mv otelcol-contrib /usr/local/bin/otelcol

COPY nrheartbeat.sh /

RUN chmod +x /nrheartbeat.sh

USER $USERNAME

SHELL [ "/bin/bash", "-c" ]

ENV SHELL=/bin/bash