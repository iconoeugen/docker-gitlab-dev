NAME = iconoeugen/gitlab-dev
TAG = latest
all: build

build:
	docker build -t $(NAME) -t $(NAME):$(TAG) .

build-nocache:
	docker build -t $(NAME) -t $(NAME):$(TAG) . --no-cache

run:
	docker run -it $(NAME):$(TAG)
