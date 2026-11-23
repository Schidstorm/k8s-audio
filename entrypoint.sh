#!/bin/bash
set -euo pipefail

mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

exec dbus-run-session -- bash -c '
    set -e

    pipewire &
    wireplumber &

    for mode in output input both; do
        mkdir -p "/run/pipewire/pulse-${mode}"

        PULSE_RUNTIME_PATH="/run/pipewire/pulse-${mode}" \
        pipewire-pulse \
          -c "/etc/pipewire/pipewire-pulse-${mode}.conf" &
    done

    trap "kill $(jobs -pr) 2>/dev/null || true" TERM INT

    wait -n
    kill $(jobs -pr) 2>/dev/null || true
    wait || true
'