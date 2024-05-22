FROM ubuntu:focal
RUN apt-get update -y && apt-get upgrade -y && apt-get install curl bash git -y
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv 
ENV PATH=/root/.tfenv/bin:$PATH
WORKDIR /demo 
USER root 
