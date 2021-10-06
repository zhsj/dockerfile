FROM golang as builder

RUN go env -w CGO_ENABLED=0
RUN go install -v -ldflags="-w -s" -trimpath github.com/zhsj/wghttp@master

FROM alpine:3.14
COPY --from=builder /go/bin/wghttp /usr/local/bin/
EXPOSE 8080
CMD ["/usr/local/bin/wghttp", "--listen=0.0.0.0:8080"]
