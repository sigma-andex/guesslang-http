#!/bin/sh
set -e
. /venv/bin/activate
ls -lah .
exec gunicorn --bind 0.0.0.0:5000 --forwarded-allow-ips='*' guesslang_http:app
