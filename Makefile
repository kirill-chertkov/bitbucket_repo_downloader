IMAGE_NAME=hexlet/bitbucket_downloader
CURRENT_USER=$(shell id -u):$(shell id -g)
UPDATE_FLAG?=

build:
	docker build -t $(IMAGE_NAME):latest .

# development
dev_build:
	docker build -t $(IMAGE_NAME):dev -f dev.Dockerfile .

dev_prepare:
	docker run --rm -it --user nobody --name bitbucket_downloader \
		-v $(CURDIR):/downloader \
		$(IMAGE_NAME):dev /bin/bash -c "chmod a+x ./downloader.py"

dev_clone:
	docker run --rm -it --user nobody --name bitbucket_downloader \
		-v $(CURDIR):/repos \
		-v $(HOME)/.ssh:/nonexistent/.ssh \
		--env-file ./bitbucket.config.env \
		$(IMAGE_NAME):dev ./downloader.py $(UPDATE_FLAG)

dev_rebase:
	make dev_clone UPDATE_FLAG=--update

# usage
clone:
	docker run --rm -it --user nobody --name hexlet/bitbucket-downloader \
		-v $(HOME)/.ssh:/nonexistent/.ssh \
		-v $(CURDIR):/repos \
		--env-file ./bitbucket.config.env \
		docker.pkg.github.com/melodyn/bitbucket_repo_downloader/hexdownloader:latest $(UPDATE_FLAG)

rebase:
	make clone UPDATE_FLAG=--update