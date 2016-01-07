TAG = 1.6
PREFIX = antob/pg-backup

all: build push

build:
	docker build -t $(PREFIX):$(TAG) .

push:
	docker push $(PREFIX):$(TAG)
