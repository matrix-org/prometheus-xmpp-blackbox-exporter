FROM golang:1.12 as builder
WORKDIR /go/src/app
COPY . .
ENV GO111MODULE on
RUN go build cmd/prometheus-xmpp-blackbox-exporter/xmpp_blackbox_exporter.go


FROM gcr.io/distroless/base
COPY --from=builder /go/src/app/xmpp_blackbox_exporter /xmpp_blackbox_exporter
COPY --from=builder /go/src/app/example.yml /config.yml
EXPOSE 9604
ENTRYPOINT ["/xmpp_blackbox_exporter"]
CMD ["-web.listen-address", "0.0.0.0:9604", "-config.file", "/config.yml"]
