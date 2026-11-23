FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive \
    XDG_RUNTIME_DIR=/run/pipewire \
    PIPEWIRE_RUNTIME_DIR=/run/pipewire

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      pipewire \
      pipewire-pulse \
      wireplumber \
      libspa-0.2-modules \
      alsa-utils \
      pulseaudio-utils \
      dbus \
      bash && \
    rm -rf /var/lib/apt/lists/*

COPY config/ /etc/pipewire/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN for mode in output input both; do \
      cp /usr/share/pipewire/pipewire-pulse.conf \
         "/etc/pipewire/pipewire-pulse-${mode}.conf"; \
      cat "/etc/pipewire/pulse-${mode}.conf" \
         >> "/etc/pipewire/pipewire-pulse-${mode}.conf"; \
    done
    
EXPOSE 4713 4714 4715

ENTRYPOINT ["/entrypoint.sh"]