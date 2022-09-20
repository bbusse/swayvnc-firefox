# swayvnc-firefox  
VNC Desktop Browser Session in a Container
---
swayvnc-firefox uses [Sway](https://swaywm.org) with [wayvnc](https://github.com/any1/wayvnc) to create a headless wayland desktop with a browser payload (firefox), to display one or several web pages

## Build
### Build dependency
Uses [swayvnc](https://github.com/bbusse/swayvnc) as base image

### Build container
```
$ podman build -t swayvnc-firefox .
```

## Run Container
```
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
           -p${LISTEN_ADDRESS}:5900:5900 \
           -p${LISTEN_ADDRESS}:7023:7023 swayvnc-firefox
```

## Run Commands
Run commands with swaymsg by using socat to put them on the network
Replace $IP with the actual IP you want to listen on
```
$ socat UNIX-LISTEN:/tmp/sway-ipc.sock,fork TCP:$IP:7023
$ SWAYSOCK=/tmp/swayipc swaymsg exec "firefox [URL]"
```

## Connect
Use a vnc client to connect to the server
```
$ wlvncc <vnc-server>
# or
$ vinagre [vnc-server:5910]
```

## TODO
* Add tab rotation for the browser payload

## Resources
[W3C WebDriver Specification](https://w3c.github.io/webdriver/)  
[Selenium/WebDriver Documentation](ww.selenium.dev/documentation/en/getting_started_with_webdriver)  
[Mozilla geckodriver](https://github.com/mozilla/geckodriver)  
