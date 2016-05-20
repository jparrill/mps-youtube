# mps-youtube in Docker

Running [mps-youtube](https://github.com/mps-youtube/mps-youtube) in Docker


## Launching mps-youtube

### with Docker Compose

```
docker-compose run --rm mps-youtube
```

Place the following alias to your `~/.bash_aliases` file  
```
alias docker="sudo -E docker"
alias docker-compose="sudo -E docker-compose"

function docker_helper_fg() { { pushd ~/docker/$1; docker-compose rm -fa "$1"; docker-compose run --name "$1" "$@"; popd; } }
function mps-youtube() { { docker_helper_fg $FUNCNAME $@; } }
```

### with Docker

```
docker run --rm -ti \
           --read-only=true \
           -v $XDG_RUNTIME_DIR/pulse:/run/user/1000/pulse:ro \
           -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
           andrey01/mps-youtube
```
