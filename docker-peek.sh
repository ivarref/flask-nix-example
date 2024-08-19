#!/usr/bin/env bash

set -eu

docker build -t dev:dev .

docker export "$(docker create "dev:dev")" | tar tf - | grep "/curl$"
