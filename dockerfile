# 打包依赖阶段使用golang作为基础镜像
FROM golang:1.14 as builder

# # CGO_ENABLED禁用cgo 然后指定OS等，启用go module
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
	GOPROXY="https://goproxy.cn,direct"

WORKDIR /app

COPY . .

#并go build
RUN go build main.go
# 运行时使用scratch作为基础镜像
FROM scratch as prod

WORKDIR /app
# 为了防止代码中请求https链接报错，我们需要将证书纳入到scratch中
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/cert

COPY --from=builder /app .
# 指定运行时环境变量
ENV GIN_MODE=release \
    PORT=80

EXPOSE 80

ENTRYPOINT ["./main"]