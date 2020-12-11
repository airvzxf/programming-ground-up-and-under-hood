# docker build -t airvzxf/pandoc .
# docker run --rm -it --cap-add=SYS_PTRACE airvzxf/pandoc

FROM alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade
RUN apk add bash
RUN apk add wget
RUN apk add pandoc
RUN apk add texmf-dist-latexextra
RUN apk add texlive
