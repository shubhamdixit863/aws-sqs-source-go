####################################################################################################
# base
####################################################################################################
FROM alpine:3.12.3 as base
ARG ARCH=amd64

RUN apk update && apk upgrade && \
    apk add ca-certificates && \
    apk --no-cache add tzdata

COPY dist/aws-sqs-source-go-${ARCH} /bin/aws-sqs-source-go
RUN chmod +x /bin/aws-sqs-source-go

####################################################################################################
# aws-sqs-source-go
####################################################################################################
FROM scratch as aws-sqs-source-go
ARG ARCH
COPY --from=base /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=base /bin/aws-sqs-source-go /bin/aws-sqs-source-go
ENTRYPOINT [ "/bin/aws-sqs-source-go" ]
