Personal Docker images

# emsdk

Version of `emscripten/emsdk` that has Ninja installed so it works with [rsms/js-wasmc](https://github.com/rsms/js-wasmc). This allows for a much newer version of Emscripten.

Right now requires this PR of `js-wasm`: https://github.com/rsms/js-wasmc/pull/3

Example of usage with `js-wasmc`:

```sh
wasmc -docker-image mbullington/emsdk:2.0.14
```

# tailscale

Published version of `tailscale/tailscale`. (https://github.com/tailscale/tailscale/issues/295)

Example of usage with `docker-compose.yml`:

```yaml
version: "3.3"
services:
  tailscale:
    hostname: lan # hostname exposed to Tailscale
    image: mbullington/tailscale
    network_mode: host
    volumes:
      - "./tailscale_var_lib:/var/lib"
      - "/dev/net/tun:/dev/net/tun"
    cap_add:
      - net_admin
      - sys_module
    command: tailscaled
  traefik:
    image: "traefik:v2.4"
    container_name: "traefik"
    network_mode: service:tailscale # IMPORTANT: Gateway should be on same network as tailscale.
    # . . . Traefik stuff here . . .
```

As per [this guide](https://rnorth.org/tailscale-docker/), on first launch you'll have to run `docker-compose exec tailscale tailscale up` to sign in.
