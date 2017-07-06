FROM alpine:latest

#Install pre-requisites
RUN apk add --update-cache --update bash gawk curl sed openssh-client file && rm -rf /var/cache/apk/*

#Install secp application
COPY secp /bin/secp
RUN chmod +x /bin/secp

ENTRYPOINT ["/bin/secp"]
CMD ["--help"]

