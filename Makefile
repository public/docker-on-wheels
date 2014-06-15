SHELL := /bin/bash

.PHONY: wheels wheel-builder

wheel-builder :
	cp app/packages.txt wheel-builder/packages.txt

	pushd wheel-builder ; \
	docker build -t wheel-builder . ; \
	popd 

wheels : wheel-builder
	docker run \
		-v ${CURDIR}/wheels/:/var/cache/wheel-builder/ \
		-e WHEEL_DIR=/var/cache/wheel-builder/wheels \
		-e DOWNLOAD_DIR=/var/cache/wheel-builder/source \
		-i \
		wheel-builder \
		/root/bin/build-wheels < app/requirements.txt

app/.wheels :
	rsync -ra wheels/wheels/ app/.wheels

app : wheels app/.wheels
	pushd app/ ; \
	docker build -t ${APP_TAG} . ; \
	popd

clean:
	docker rmi wheel-builder

