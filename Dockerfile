# build
FROM golang:1.13 AS builder
WORKDIR /build
COPY . .

ARG GOOS
ARG GOARCH
RUN CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o common_graphql .

# create final image
FROM scratch
EXPOSE 8080
COPY --from=builder /build/common_graphql /app/
WORKDIR /app
ENTRYPOINT [".common_graphql"]
