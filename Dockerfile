FROM openjdk:8-jre


# Updating container
RUN apt-get update && \
	apt-get install apt-utils --yes && \
	apt-get upgrade --yes --allow-remove-essential && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Setting workdir
WORKDIR /minecraft

# Creating user and downloading files
RUN useradd -m -U minecraft && \
	mkdir -p /minecraft/world && \
	wget --no-check-certificate https://api.modpacks.ch/public/modpack/35/174/server/linux -O serverinstall_35_174 && \
	chmod u+x serverinstall_* && \
	echo "y" | ./serverinstall_* && \
	rm serverinstall_* && \
	echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.txt && \
	echo "eula=TRUE" >> eula.txt && \
	chown -R minecraft:minecraft /minecraft
	
# Removing faulty EULA check
RUN sed -i '2,6d' /minecraft/start.sh

#Change working directory to add Sponge and plugins 
WORKDIR /minecraft/mods

#install sponge and rename to ensure no conflicts with mixin ordering
ADD https://repo.spongepowered.org/maven/org/spongepowered/spongeforge/1.12.2-2838-7.3.1-RC4093/spongeforge-1.12.2-2838-7.3.1-RC4093.jar aaa_spongeforge-1.12.2-2838-7.3.1-RC4093.jar

#Add plugins (WIP)

#Change working directory back to 
WORKDIR /minecraft

# Changing user to minecraft
USER minecraft

# Expose port 25565
EXPOSE 25565

# Expose volume
VOLUME ["/minecraft/world"]

# Start server
CMD ["/bin/bash", "/minecraft/start.sh"]
