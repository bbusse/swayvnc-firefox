ARG SWAYVNC_VERSION=latest
FROM ghcr.io/bbusse/swayvnc:${SWAYVNC_VERSION}
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/swayvnc-firefox

ENV ARCH="x86_64" \
    USER="firefox-user" \
    APK_ADD="libc-dev libffi-dev libxkbcommon-dev gcc geckodriver@testing git python3 python3-dev py3-pip py3-wheel firefox" \
    APK_DEL=""

USER root

# Add application user and application
# Cleanup: Remove files and users
RUN addgroup -S $USER && adduser -S $USER -G $USER \
    && echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # https://gitlab.alpinelinux.org/alpine/aports/-/issues/11768
    && sed -i -e 's/https/http/' /etc/apk/repositories \
    # Add packages
    && apk add --no-cache ${APK_ADD} \
    && apk del --no-cache ${APK_DEL} \
    # Cleanup: Remove files
    && rm -rf \
      /usr/share/man/* \
      /usr/includes/* \
      /var/cache/apk/* \

    # Add latest webdriver-util script for firefox automation
    && wget -P /usr/local/bin https://raw.githubusercontent.com/bbusse/webdriver-util/main/webdriver_util.py \
    && chmod +x /usr/local/bin/webdriver_util.py \
    && wget -O /tmp/requirements_webdriver.txt https://raw.githubusercontent.com/bbusse/webdriver-util/main/requirements.txt \

    && git clone -b dev https://github.com/bbusse/python-wayland /usr/local/src/python-wayland \

    # Add iss-display-controller for view handling
    && wget -P /usr/local/bin https://raw.githubusercontent.com/OpsBoost/iss-display-controller/dev/controller.py \
    && chmod +x /usr/local/bin/controller.py \
    && wget -O /tmp/requirements_controller.txt https://raw.githubusercontent.com/OpsBoost/iss-display-controller/dev/requirements.txt \

    # Run controller.py
    && echo "exec controller.py --uri="iss-weather://" --stream-source=vnc-browser --debug=$DEBUG" >> /etc/sway/config.d/firefox

USER $USER

RUN pip3 install --user -r /tmp/requirements_controller.txt
RUN pip3 install --user -r /tmp/requirements_webdriver.txt

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
