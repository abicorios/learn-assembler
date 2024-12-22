FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    nasm \
    build-essential \
    gdb

WORKDIR /app
