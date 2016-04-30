# mps-youtube in Docker

Running [mps-youtube](https://github.com/mps-youtube/mps-youtube) in Docker


## Launching mps-youtube

### with Docker Compose

```
docker-compose run --rm mps-youtube
```

### with Docker

```
docker run --rm -ti \
           --read-only=true \
           -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
           -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
           andrey01/mps-youtube
```
