FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

RUN apt-get update && \
    apt-get -y install python3 virtualenv mpv

# Workaround: pulseaudio client library likes to remove /dev/shm/pulse-shm-*
#             files created by the host, causing sound to stop working.
#             To fix this, we either want to disable the shm or mount /dev/shm
#             in read-only mode when starting the container.
RUN echo "enable-shm = no" >> /etc/pulse/client.conf

ENV USER user
ENV UID 1000
ENV GROUPS audio
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin -G $GROUPS $USER

USER $USER
WORKDIR $HOME

RUN virtualenv -p python3 venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install mps-youtube youtube-dl && \
    deactivate &&\
    mkdir $HOME/.config

VOLUME [ "/tmp", "$HOME/.config" ]
ENTRYPOINT [ "./venv/bin/mpsyt" ]
