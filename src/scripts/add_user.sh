#!/usr/bin/env bash
USER_NAME=hobby
USER_PASSWORD=hobby
useradd -m -s /usr/bin/fish ${USER_NAME}
echo -e "${USER_PASSWORD}\n${USER_PASSWORD}" | passwd ${USER_NAME}
usermod -aG adm ${USER_NAME}
echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_NAME}"