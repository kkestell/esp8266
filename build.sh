#!/bin/bash

set -e

TARGETS=("blink")
FQBN="esp8266:esp8266:d1_mini"
PORT="/dev/ttyUSB0"

usage() {
    echo "Usage: $0 [build|upload] [target]"
    echo "Available targets: ${TARGETS[*]}"
    exit 1
}

build() {
    local target=$1
    if [[ "$target" == "lua" ]]; then
        arduino-cli compile --fqbn "$FQBN" --library $target/lua "$target/$target.ino"
    else
        arduino-cli compile --fqbn "$FQBN" "$target/$target.ino"
    fi
}

upload() {
    local target=$1
    arduino-cli upload --fqbn "$FQBN" --port "$PORT" "$target/$target.ino"
}

main() {
    local action=$1
    local target=$2

    if [[ -z "$action" ]]; then
        usage
    fi

    case "$action" in
        build)
            if [[ -z "$target" ]]; then
                for t in "${TARGETS[@]}"; do
                    build "$t"
                done
            else
                build "$target"
            fi
            ;;
        upload)
            if [[ -z "$target" ]]; then
                usage
            fi
            upload "$target"
            ;;
        *)
            usage
            ;;
    esac
}

main "$@"
