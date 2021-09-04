FROM golang as builder

COPY . src
RUN go env -w CGO_ENABLED=0
RUN cd src && go build -ldflags="-w -s" -trimpath -o /warp .

FROM alpine:3.14
COPY --from=builder /warp /usr/local/bin/
EXPOSE 8080
CMD /usr/local/bin/warp
