#!/usr/bin/env sh

export LISTEN_ADDRESS="127.0.0.1";

podman run -e XDG_RUNTIME_DIR=/tmp \
           -e WLR_BACKENDS=headless \
           -e WLR_LIBINPUT_NO_DEVICES=1 \
           -e SWAYSOCK=/tmp/sway-ipc.sock \
           -e MOZ_ENABLE_WAYLAND=1 \
           -e TARGET="grafana" \
           -e URL="https://grafana.example.com" \
           -e LOGIN_USER="foo" \
           -e LOGIN_PW="c3VwZXJTZWNyZXRQYXNzd3JvZAo=" \
           -p${LISTEN_ADDRESS}:5910:5910 \
           -p${LISTEN_ADDRESS}:7023:7023 swayvnc-firefox
