#!/usr/bin/env bash

set -eu

docker build -t flask-example:dev .

docker export "$(docker create "flask-example:dev")" | tar tf - | grep "/curl$"
#docker export "$(docker create "flask-example:dev")" | tar tf - | grep "/bash$"