FROM ubuntu
ARG UID
ARG GID
ARG USER

# Create users and groups
RUN useradd --uid $UID  --create-home $USER && \
    groupadd --gid $GID media && \
    usermod -a -G media $USER

# RUN add-apt-repository ppa:deluge-team/stable
RUN apt update && apt install -y deluged deluge-web deluge-console gosu

VOLUME /data
VOLUME /home/${USER}/.config/${USER}
EXPOSE 8112

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /home/$USER
CMD [ "/entrypoint.sh" ]
