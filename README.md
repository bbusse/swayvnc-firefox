# swayvnc-firefox - VNC Desktop Browser Session in a Container
swayvnc-firefox uses [Sway](https://swaywm.org) with [wayvnc](https://github.com/any1/wayvnc) to create a headless wayland desktop with a browser payload (firefox), to display one or several web pages

## Build
### Build dependency
Uses [swayvnc](https://github.com/bbusse/swayvnc) as base image

### Build container
```
$ podman build -t swayvnc-firefox .
```

## Run Container
Run container
```
export LISTEN_ADDRESS="127.0.0.1"; podman run -e XDG_RUNTIME_DIR=/tmp \
             -e WLR_BACKENDS=headless \
             -e WLR_LIBINPUT_NO_DEVICES=1 \
             -e SWAYSOCK=/tmp/sway-ipc.sock
             -p${LISTEN_ADDRESS}:5900:5900 \
             -p${LISTEN_ADDRESS}:7023:7023 swayvnc-firefox
```

## Run Commands
Run commands with swaymsg by using socat to put them on the network
Replace $IP with the actual IP you want to listen on
```
$ socat UNIX-LISTEN:/tmp/swayipc,fork TCP:$IP:7023
$ SWAYSOCK=/tmp/swayipc swaymsg command exec "firefox [URL]"
```

## Connect
Use some vnc client to connect the server
```
$ wlvncc <vnc-server>
# or
$ vinagre [vnc-server:5900]
```

## TODO
* Add tab rotation for the browser payload

## Resources
[geckodriver in Alpine](https://stackoverflow.com/questions/58738920/running-geckodriver-in-an-alpine-docker-container)
