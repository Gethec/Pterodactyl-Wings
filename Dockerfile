FROM docker
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2"
COPY root/ /

# Download latest Wings build from project repository: https://github.com/pterodactyl/wings
ADD https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64 /usr/bin/wings

# Download latest S6-Overlay build from project repository: https://github.com/just-containers/s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/s6-overlay

# Download common tools
ADD https://raw.githubusercontent.com/Gethec/ProjectTools/main/DockerUtilities/ContainerTools /usr/bin/ContainerTools

# Upgrade installed packages, install new ones
RUN apk --no-cache add \
        bash \
        tzdata && \
    # Install S6-Overlay, enable execution of Wings
    chmod u+x /tmp/s6-overlay /usr/bin/wings && \
    /tmp/s6-overlay / && \
    # Container cleanup
    rm -rf /tmp/*

# Expose ports: 8080 for webservice, 2022 for SFTP
EXPOSE 8080
EXPOSE 2022

# Set entrypoint to S6-Overlay
ENTRYPOINT ["/init"]