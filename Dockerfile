ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH
ARG VERSION
ENV FRPC_VERSION=${VERSION}

ENV APP_PATH="/usr/src"

RUN apk add --no-cache curl tar

# 根据架构选择正确的二进制文件
RUN \
    case "$BUILD_ARCH" in \
        "aarch64") MACHINE="arm64" ;; \
        "amd64")   MACHINE="amd64" ;; \
        "armhf")   MACHINE="arm" ;; \
        "armv7")   MACHINE="arm" ;; \
        "i386")    MACHINE="386" ;; \
    esac && \
    FILE_NAME="frp_${FRPC_VERSION}_linux_${MACHINE}.tar.gz" && \
    FILE_DIR="frp_${FRPC_VERSION}_linux_${MACHINE}" && \
    curl -L -o /tmp/${FILE_NAME} \
        "https://github.com/fatedier/frp/releases/download/v${FRPC_VERSION}/${FILE_NAME}" && \
    mkdir -p ${APP_PATH} && \
    tar xzf /tmp/${FILE_NAME} -C /tmp && \
    cp -f /tmp/${FILE_DIR}/frpc ${APP_PATH}/ && \
    rm -rf /tmp/${FILE_NAME} /tmp/${FILE_DIR}

# 复制启动脚本
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]