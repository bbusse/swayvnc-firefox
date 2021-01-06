export LISTEN_ADDRESS="127.0.0.1";

podman run -e XDG_RUNTIME_DIR=/tmp \
             -e WLR_BACKENDS=headless \
             -e WLR_LIBINPUT_NO_DEVICES=1 \
             -e SWAYSOCK=/tmp/sway-ipc.sock \
             -p${LISTEN_ADDRESS}:5910:5910 \
             -p${LISTEN_ADDRESS}:7023:7023 swayvnc-firefox
