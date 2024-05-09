FROM alpinelinux/golang

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY server.go ./
RUN go build server.go

CMD [ "./server" ]
