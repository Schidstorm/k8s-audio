version = $(shell tomlq -r '.tool.commitizen.version' .cz.toml)

all: build push deploy

build:
	docker build -t registry.schidlow.ski/k8s-audio:$(version) .

push:
	docker push registry.schidlow.ski/k8s-audio:$(version)
	
deploy:
	cat application.yaml | VERSION=$(version) envsubst | kubectl apply -f -