FROM alpine:latest as builder
WORKDIR /root
RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/lzcapp/vlmcsd.git && \
    cd vlmcsd && \
    make

FROM alpine:latest
COPY --from=builder /root/vlmcsd/bin/vlmcs /vlmcs
COPY --from=builder /root/vlmcsd/bin/vlmcsd /vlmcsd
COPY --from=builder /root/vlmcsd/etc/vlmcsd.kmd /vlmcsd.kmd
RUN apk add --no-cache tzdata

EXPOSE 1688/tcp

CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]

HEALTHCHECK --interval=5s --timeout=3s CMD /vlmcs || exit 1
