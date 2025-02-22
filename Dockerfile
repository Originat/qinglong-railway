FROM whyour/qinglong:latest
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo root:york618|chpasswd
EXPOSE 22
RUN apk add wget curl
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
RUN tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
RUN ngrok config add-authtoken 2C0c8UpBZMkGB9BsW7QDifKD7Sa_5DNVJt6RCjkuymVyjRh5p
RUN setsid ngrok tcp 22

ARG QL_MAINTAINER="whyour"
LABEL maintainer="${QL_MAINTAINER}"
ARG QL_URL=https://github.com/${QL_MAINTAINER}/qinglong.git
ARG QL_BRANCH=master

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
＃    QL_DIR=/ql \
    QL_BRANCH=${QL_BRANCH}

WORKDIR ${QL_DIR}

＃RUN mv /ql

RUN git clone -b ${QL_BRANCH} ${QL_URL} \
    && cd qinglong \
    && cp -f .env.example .env \
    && chmod 777 qinglong/shell/*.sh \
    && chmod 777 qinglong/docker/*.sh \
    && cp -rf /node_modules ./ \
    && rm -rf /node_modules \
    && pnpm install --prod \
    && rm -rf /root/.pnpm-store \
    && rm -rf /root/.cache \
    && git clone -b ${QL_BRANCH} https://github.com/${QL_MAINTAINER}/qinglong-static.git /static \
    && cp -rf /static/* qinglong \
    && rm -rf /static
ENTRYPOINT ["./docker/docker-entrypoint.sh"]
