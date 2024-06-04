FROM alpinelinux/golang

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY server.go ./
RUN go build server.go
# Install the Delve debugger
RUN go install github.com/go-delve/delve/cmd/dlv@latest
COPY templates ./templates

CMD [ "./server" ]
