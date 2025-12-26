include ./MANIFEST
include ./scripts/release.mk

DATE := $(shell date | sed 's/\ /_/g')

GOPATH ?= $$PWD/../../../..
GOOS ?= linux

SERVER_SWAGGER_FILE=api/server.yml

PKGS := $(shell go list ./... | grep -vF /vendor/)

PACKAGE_NAME=denon
PACKAGE_PATH=github.com/home-IoT/$(PROJECT)/internal/$(PACKAGE_NAME)

# --- Docker
IMAGE_NAME=$(PROJECT)
DOCKER_REGISTRY=theroozbeh
TAG=$(VERSION)

OS=$(shell uname)
CMD_XARGS=xargs
ifeq "$(OS)" "Linux"
	CMD_XARGS=xargs -r
endif

# --- Repo 

initialize: clean swagger-gen

clean:
	mkdir -p bin
	rm -rf ./bin/*
	rm -rf ./pkg/*

# --- Tools

get-tools:
	go get -u github.com/golang/lint/golint
	curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# --- Swagger

get-swagger:
	go get -u github.com/go-swagger/go-swagger/cmd/swagger

swagger-serve:
	swagger serve $(SERVER_SWAGGER_FILE)

swagger-validate:
	swagger validate $(SERVER_SWAGGER_FILE)

swagger-gen:
	mkdir -p gen
	swagger generate server -f $(SERVER_SWAGGER_FILE) -t gen -A denon

# --- Common Go

go-fmt:
	@go fmt $(PKGS)

go-validate:
	@echo go vet
	@go vet $(PKGS)
	@echo golint
	@golint -set_exit_status $(PKGS)

# --- Server

go-build-linux:
	@echo "build linux binary"
	$(MAKE) go-build GOOS=linux GOARCH=amd64 TARGET=$(PROJECT)-linux-amd64

go-build-pi:
	@echo "build linux binary for raspberry pi"
	$(MAKE) go-build GOOS=linux GOARCH=arm GOARM=7 TARGET=$(PROJECT)-linux-arm7

go-build-windows:
	@echo "build windows binary"
	$(MAKE) go-build GOOS=windows GOARCH=386 TARGET=$(PROJECT)-windows-386.exe

go-build-mac:
	@echo "build Mac binary"
	$(MAKE) go-build GOOS=darwin GOARCH=amd64 TARGET=$(PROJECT)-darwin-amd64

TARGET ?= $(PROJECT)

go-build: 
	go build -ldflags="-X $(PACKAGE_PATH).GitRevision=$(shell git rev-parse HEAD) -X $(PACKAGE_PATH).BuildVersion=$(VERSION) -X $(PACKAGE_PATH).BuildTime=$(DATE)" -o ./bin/$(TARGET) gen/cmd/$(PACKAGE_NAME)-server/main.go

go-build-all: go-build-pi go-build-linux go-build-windows go-build-mac

run: go-build
	./bin/$(TARGET) -c configs/test.yml

# --- Release

go-release-all: clean
	$(MAKE) go-build-all
	mkdir -p ./release
	rm -rf ./release/*
	chmod +x bin/*
	cp ./bin/* ./release
	for bf in ./release/*; do shasum -a 256 "$$bf" > "$$bf".sha256; done

# --- Docker

.PHONY: docker-clean docker-build docker-run docker-push

docker-clean:
	docker ps -a -q --filter name=$(IMAGE_NAME) | $(CMD_XARGS) docker stop | $(CMD_XARGS) docker rm

docker-build: docker-clean
	docker build --pull --force-rm --tag $(IMAGE_NAME)\:$(TAG) .

docker-run: docker-clean
	docker run --name $(IMAGE_NAME) $(IMAGE_NAME)\:$(TAG)

docker-push: docker-build
	docker tag $(IMAGE_NAME)\:$(TAG) $(DOCKER_REGISTRY)/$(IMAGE_NAME)\:$(TAG)
	docker tag $(IMAGE_NAME)\:$(TAG) $(DOCKER_REGISTRY)/$(IMAGE_NAME)\:latest
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)\:$(TAG)
	docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME)\:latest

