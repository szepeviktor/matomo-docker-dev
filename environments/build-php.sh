#!/usr/bin/env bash

cd $(dirname "$0")

mkdir -p ./phps

PHP_VERSION="$1"
if [[ -z "${PHP_VERSION// }" ]]; then
    echo "First argument must be a php version.";
    exit 1;
fi

docker-compose run --rm phpbrew "$PHP_VERSION"
