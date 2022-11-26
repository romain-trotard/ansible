FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get install -y sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS rainbow
ARG TAGS
RUN addgroup --system --gid 1000 ronron
RUN adduser --gecos ronron --uid 1000 --gid 1000 --disabled-password ronron
RUN adduser ronron sudo

# Remove password for every users
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ronron
WORKDIR /home/ronron

FROM rainbow
COPY . .
RUN ["sh", "-c", "ansible-playbook local.yml"]
