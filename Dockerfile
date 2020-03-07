FROM golang:alpine AS build
RUN apk --no-cache add gcc g++ make git
WORKDIR /go/src/app
COPY . .
RUN go get ./...
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/web-app ./main.go

FROM alpine:3.9
RUN apk --no-cache add ca-certificates
RUN adduser -D myuser
WORKDIR /home/myuser
COPY --from=build /go/src/app/bin /home/myuser
RUN chmod -R g+rwX /home/myuser
USER myuser
EXPOSE 8800
ENTRYPOINT ["/home/myuser/web-app"]
CMD ["--port", "8800"]
