FROM ubuntu AS builder
ARG UID
ARG GID
ARG USER

# Create users and groups
RUN useradd --uid $UID  --create-home $USER && \
    groupadd --gid $GID media && \
    usermod -a -G media $USER

FROM builder
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
USER $USER
WORKDIR /home/$USER
CMD [ "/entrypoint.sh" ]
