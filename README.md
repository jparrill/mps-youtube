# mps-youtube in Docker

Running [mps-youtube](https://github.com/mps-youtube/mps-youtube) in Docker


## Launching mps-youtube

### with Docker Compose

```
docker-compose run --rm mps-youtube
```

You can use the following alias and place it to your `~/.bash_aliases` file

```
alias mps-youtube='(cd ~/docker/mps-youtube; docker-compose run --rm mps-youtube)'
```

### with Docker

```
docker run --rm -ti \
           --read-only=true \
           -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
           -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
           andrey01/mps-youtube
```
