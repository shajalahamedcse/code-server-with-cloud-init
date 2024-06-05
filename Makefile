IMAGE_NAME := code-server-cloud-init
DOCKER_USERNAME := sagoresarker
TAG=v0.0.2


build:
	@ docker build -t $(IMAGE_NAME):$(TAG) -f Dockerfile .

push:
	@ docker tag $(IMAGE_NAME):$(TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)
	@ docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)

clean:
	@ docker rmi $(IMAGE_NAME):$(TAG)
