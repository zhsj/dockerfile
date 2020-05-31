FROM golang as builder

COPY . src
RUN go env -w CGO_ENABLED=0
RUN cd src && go build -ldflags="-w -s" -trimpath -o /goproxy .

FROM alpine
COPY --from=builder /goproxy /usr/local/bin/
VOLUME /cache
CMD /usr/local/bin/goproxy
