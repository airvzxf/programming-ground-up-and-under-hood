# docker build -t pandoc .
# docker run -it --rm pandoc
FROM ubuntu:24.10

WORKDIR /root/

RUN TZ=America/New_York && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

ADD ./generate_action_cache.sh ./
