FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

RUN apt-get update && \
    apt-get -y install python3 virtualenv mpv paxctl && \
    apt-get clean all

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

WORKDIR /opt
RUN virtualenv -p python3 venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install mps-youtube youtube-dl && \
    deactivate

# Make mps-youtube grsec friendly
# more info: https://en.wikibooks.org/wiki/Grsecurity/Application-specific_Settings#Firefox_.28or_Iceweasel_in_Debian.29
#
# To build the Docker image, I currently had to disable the following grsec protections:
# # grep -E "chroot_deny_chmod|chroot_deny_mknod|chroot_caps" /etc/sysctl.d/grsec.conf
# kernel.grsecurity.chroot_deny_chmod = 0
# kernel.grsecurity.chroot_deny_mknod = 0
# kernel.grsecurity.chroot_caps = 0 (relates to a systemd package)
#
# (runtime only, since xattrs are not preserved in Docker's final image)
# m: Disable MPROTECT // grsec: denied RWX mmap of <anonymous mapping>
# RUN setfattr -n user.pax.flags -v "m" /opt/venv/bin/python3
#
# (permanent change, by converting the binary headers PT_GNU_STACK into PT_PAX_FLAGS)
# m: Disable MPROTECT // grsec: denied RWX mmap of <anonymous mapping>
RUN paxctl -c -v -m /opt/venv/bin/python3

USER $USER
WORKDIR $HOME
RUN mkdir .config

VOLUME [ "/tmp", "$HOME/.config" ]
ENTRYPOINT [ "/opt/venv/bin/mpsyt" ]
