FROM alpine

RUN apk add --no-cache \
    coreutils \
    curl \
    openvpn \
    privoxy && \
    rm -r /etc/privoxy/* && \
    touch /etc/privoxy/config

COPY vpnStart.sh /bin/
ENTRYPOINT ["vpnStart.sh"]
