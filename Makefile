SHELL := /bin/bash

.PHONY: wheels wheel-builder app clean

wheel-builder : app/wheel-build-dep-packages.txt
	cp -p app/wheel-build-dep-packages.txt wheel-builder/packages.txt

	pushd wheel-builder ; \
	docker build -t wheel-builder . ; \
	popd 

wheels : wheel-builder app/requirements.txt
	docker run \
		-v ${CURDIR}/wheels/:/var/cache/wheel-builder/ \
		-e WHEEL_DIR=/var/cache/wheel-builder/wheels \
		-e DOWNLOAD_DIR=/var/cache/wheel-builder/source \
		-i \
		wheel-builder \
		/root/bin/build-wheels < app/requirements.txt

app/.wheels :
	rsync -a wheels/wheels/ app/.wheels

app : wheels app/.wheels
	pushd app/ ; \
	docker build -t ${APP_TAG} . ; \
	popd

clean :
	rm -rf wheels
	rm wheel-builder/packages.txt
	docker rmi wheel-builder

