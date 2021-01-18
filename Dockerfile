#Docker Script that auto installs a modded FTB revelations server and adds sponge the plugin manager. auto install of plugins is a work in progress.


FROM openjdk:8-jre

#Ensure clean container
RUN apt-get update && \
	apt-get install apt-utils --yes && \
	apt-get upgrade --yes --allow-remove-essential && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* 

#Set working directory
WORKDIR /datadrive/minecraft

#Add user, assign permissions to folder, launch server executable to fetch data.
RUN useradd -m -U minecraft && \
	mkdir -p /minecraft/world && \
	wget https://api.modpacks.ch/public/modpack/35/174/server/linux -O serverinstall_35_174 && \
	chmod u+x serverinstall_* &&\
	echo "y" | ./serverinstall_* && \
	rm serverinstall_* && \
	echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.text && \
	echo "eula=TRUE" >> eula.txt && \ 
	chown -R minecraft:minecraft /minecraft

#remove the glitched eula.txt 
RUN sed -i '2,6d' /minecraft/start.sh

#install sponge
RUN wget https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/1.12.2-2838-7.3.1-RC4093/spongeforge-1.12.2-2838-7.3.1-RC4093.jar &&/
cp spongeforge-1.12.2-2838-7.3.1-RC4093.jar /minecraft/mods

#Install plugins (WIP)

#Change user to Minecraft
USER minecraft 

#Expose minecraft port
EXPOSE 25565

#volume
VOLUME ["/minecraft/world"]

#start server
CMD ["bin/bash", "/minecraft/start.sh"]
