FROM jellyfin/jellyfin:latest
ARG UID
ARG GID
ARG USER

USER root

# Create users and groups
RUN useradd --uid $UID  --create-home $USER && \
    groupadd --gid $GID media && \
    usermod -a -G media $USER

RUN apt-get update && apt-get install -y --no-install-recommends gosu \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /home/$USER
ENTRYPOINT [ "/entrypoint.sh" ]
