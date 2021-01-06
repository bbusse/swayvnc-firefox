#!/usr/bin/env sh
set -o errexit

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- sway
    ;;
esac

exec "$@"
