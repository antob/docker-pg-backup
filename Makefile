TAG = 1.4
PREFIX = antob/pg-backup

all: build push

build:
	docker build -t $(PREFIX):$(TAG) .

push:
	docker push $(PREFIX):$(TAG)
