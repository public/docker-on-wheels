docker-on-wheels
================

This is a simple collection of scripts for working with Python Wheels and
Docker containers. The aim is to isolate the building of Wheels from their
installation and use such that things like compilers and header files don't
need to be installed into the applications container to properly pip install.

Requirements
------------

Bash, GNU Make, Rsync, Docker.

Usage
-----

 1. Symlink ``app`` to your application.
 2. Add system build dependencies to ``app/wheel-build-dep-packages.txt``
 3. Add desired things to build to ``app/requirements.txt``
 4. Setup ``app/Dockerfile`` to load the wheels.
    e.g. ``ADD .wheels /var/cache/wheels`` and point pip at them with
    ``--find-links``.
 5. ``APP_TAG=foo make app`` Will build all the wheels and your app.
