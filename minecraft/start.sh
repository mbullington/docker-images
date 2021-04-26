#!/bin/bash

cd /minecraft

# set EULA to true
echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Mon Aug 06 18:11:14 UTC 2018
eula=true' > eula.txt

if [[ -z "${MODPACK_URL_RAR}" ]]; then
    echo "Skipping modpack refresh due to empty URL."
else
    wget -O "server-pack.rar" "$MODPACK_URL_RAR"
    unrar x -r server-pack.rar
    rm server-pack.rar

    # remove any client side mods.
    for value in $MODPACK_MODS_BLACKLIST
    do
        rm mods/"$value"*
    done
fi

# start mcsleepingserverstarter (which will read sleepingSettings.yml)
/usr/bin/sleepingServerStarter.run
