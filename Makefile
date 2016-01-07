TAG = 1.5
PREFIX = antob/pg-backup

all: build push

build:
	docker build -t $(PREFIX):$(TAG) .

push:
	docker push $(PREFIX):$(TAG)
