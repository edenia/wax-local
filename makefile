-include .env

LATEST_TAG ?= latest

run: ##@devops Run the docker image
run:
	@docker run -dp 8888:8888 wax-local

build-docker: ##@devops Build the docker image
build-docker: ./Dockerfile
	@echo "DOCKER IMAGE"
	echo "Building contain..."
	@docker pull $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG) || true
	@docker build \
		-t wax-local \
		--build-arg testnet_eosio_private_key="$(TESTNET_EOSIO_PRIVATE_KEY)" \
		--build-arg testnet_eosio_public_key="$(TESTNET_EOSIO_PUBLIC_KEY)" \
		.

push-image: ##@devops Push the freshly built image and tag with release or latest tag
push-image:
	@docker push $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(LATEST_TAG)