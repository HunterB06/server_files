FROM ubuntu
ARG UID
ARG GID
ARG USER

# Create users and groups
RUN useradd --uid $UID  --create-home $USER && \
    groupadd --gid $GID media && \
    usermod -a -G media $USER

RUN apt update && apt install -y curl sqlite3 ca-certificates libicu-dev gosu &&\
    curl -L 'http://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'\
    | tar -xz -C /opt/

VOLUME /home/${USER}/.config/${USER}
EXPOSE 9696

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /home/$USER
CMD [ "/entrypoint.sh" ]
