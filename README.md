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

# minecraft

Lightweight container for Minecraft that doesn't assume much about your config. This means you can easily use it with Vanilla, Forge, etc and have lots of manual control.

You should mount your Minecraft root folder into `/minecraft`.

What the container does:
- Installs Java 11 (Amazon Corretto)
- Fills out `eula.txt` which is obnoxious.
- Optionally downloads modpack (as a RAR) from an external URL and installs it.
- Handles lifecycle of server with `mcsleepingserverstarter`

## Example

`docker-compose.yml`:

```yml
version: "3.3"
services:
    mc1:
        container_name: mc1
        image: "mbullington/minecraft"
        ports:
            - "25565:25565"
            - "25575:25575" # RCON port.
        volumes:
            - ./minecraft:/minecraft
        environment:
            - MODPACK_URL_RAR=https://someurl.com/modpack.rar
            - "MODPACK_MODS_BLACKLIST=Optifine moreoverlays" # Client-side mods that would otherwise crash our server.
```

Additionally, we'll need a `sleepingSettings.yml` file in `/minecraft`. See [mcsleepingserverstarter](https://github.com/vincss/mcsleepingserverstarter) for documentation.

`sleepingSettings.yml`:

```yml
serverName: Michael's MC1   # settings for SleepingServerStarter

serverPort: 25565
loginMessage: ...Waking server up, come back in a minute...
serverOnlineMode: true      # to check the licence of player or not.

webPort: 0	 			    # 0 to disable web hosting (8123 default dynmap)
webDir: plugins/dynmap/web 	# dir of dynmap web (currently not working)

startMinecraft: 1
minecraftCommand: java -Xms512M -Xmx3G -jar forge-1.14.4-28.2.0.jar nogui
```

In order for `mcsleepingserverstarter` you'll need some kind of plugin to suspend the server if there are no players. [mcEmptyServerStopper](https://github.com/vincss/mcEmptyServerStopper) is one option for Spigot, seems pretty simple so you could easily port to Forge?
