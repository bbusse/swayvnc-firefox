#!/usr/bin/env python3

import configargparse
import logging
import os
import tty
import subprocess
from subprocess import Popen,PIPE
import sys
import time
from flask import Flask

app = Flask(__name__)
cmd_sway = '/usr/bin/sway'


@app.route("/")
def info():
    return app


# Readiness
@app.route('/healthy')
def healthy():
    return "OK"


# Liveness
@app.route('/healthz')
def healthz():
    return probe_liveness()


def list_processes():
    ps = subprocess.Popen(['ps', 'aux'], stdout=subprocess.PIPE).communicate()[0]
    return ps


def probe_liveness():
    return "OK"


if __name__ == "__main__":

    parser = configargparse.ArgParser( description="")
    parser.add_argument('--listen-address', dest='listen_address', help="The address to listen on", type=str, default="0.0.0.0")
    parser.add_argument('--debug', dest='debug', help="Show debug output", type=bool, default=False)
    args = parser.parse_args()

    listen_address = args.listen_address
    debug = args.debug

    env = os.environ.copy()
    for k, v in env.items():
        print(k + '=' + v)

    # Start desktop and vnc session
    try:
        print('bla')

    except Exception as e:
        print(e)
        print('Failed to start desktop session: ', cmd_sway)
        sys.exit(1)

    if debug:
        print(list_processes().decode())

    # Start browser
    p = Popen(['webdriver_util.py'], stdout=PIPE, stderr=PIPE, env=env, start_new_session=True, close_fds=False)
    output, error = p.communicate()
    output = output.splitlines()
    error = error.splitlines()
    for line in output:
        logging.info(line)
    for line in error:
        logging.info(line)

    # Start webserver
    app.run(host=listen_address)

    print("App started successfully")
