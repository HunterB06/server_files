FROM ubuntu
ARG UID
ARG GID
ARG USER

# Create users and groups
RUN useradd --uid $UID  --create-home $USER && \
    groupadd --gid $GID media && \
    usermod -a -G media $USER

RUN apt update && apt install -y curl sqlite3 ca-certificates libicu-dev gosu &&\
    curl -L 'https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64'\
    | tar -xz -C /opt/

VOLUME /data
VOLUME /home/${USER}/.config/${USER}
EXPOSE 8989

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /home/$USER
CMD [ "/entrypoint.sh" ]
