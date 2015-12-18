#!/usr/bin/env bash

cd /data/ark

if [ ${CHECKFILES} == "true" ]; then
        ARKVALIDATE="validate"
fi

if [ ${RCON} == "true" ]; then
        ARKRCON="?RCONEnabled=True?RCONPort=32330"
fi

# Get steamcmd
if [ ! -f steamcmd_linux.tar.gz ]; then
        echo -e "Grabbing SteamCMD...\n"
        wget -q https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
        tar -xf steamcmd_linux.tar.gz
fi

# Backup before updating just to be safe
if [ -d /data/ark/arkdedicated/ShooterGame/Saved ]; then
        echo -e "Backing up Saved folder...\n"
        if [ ! -d /data/ark/backup/ ]; then
                mkdir /data/ark/backup/
        fi
        tar czf /data/ark/backup/Saved-startup_$(date +%Y-%m-%d_%H-%M).tar.gz /data/ark/arkdedicated/ShooterGame/Saved
fi


# Update / install server
echo -e "Updating ARK...\n"
./steamcmd.sh +login anonymous +force_install_dir /data/ark/arkdedicated +app_update 376030 ${ARKVALIDATE} +quit


# Start ARKRemote
cd /data/ark/arkdedicated/ShooterGame/Binaries/Linux/
export LD_LIBRARY_PATH=/data/ark/arkdedicated/

/usr/bin/mono /data/ark/ARKRemote/ARKRemote.exe
