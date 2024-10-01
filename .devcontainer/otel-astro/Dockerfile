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

COPY configure_environment.sh /

RUN chmod +x /configure_environment.sh

RUN mkdir -p /demo/scripts/src/ \
    cd /demo/scripts/ && \ 
    wget https://github.com/open-telemetry/opentelemetry-demo/archive/refs/tags/1.10.0.zip && \
    unzip 1.10.0.zip -d /demo/scripts && \
    cp -R /demo/scripts/opentelemetry-demo-1.10.0/src/frontend /demo/scripts/src/ && \
    cp -R /demo/scripts/opentelemetry-demo-1.10.0/pb /demo/scripts/

COPY frontend_image/docker-compose.yaml /demo/scripts

COPY frontend_image/_document.tsx /demo/scripts/src/frontend/pages

RUN sudo rm -rf /demo/scripts/opentelemetry-demo-1.10.0/

USER $USERNAME

COPY install_demo.sh /

RUN sudo chmod +x /install_demo.sh

