#!/bin/bash

# Permitir acesso ao X11 para o Docker
xhost +local:docker
export UID=$(id -u)
export GID=$(id -g)
# Iniciar o docker-compose
docker compose up --build

# Opcional: Reverter permissões do X11 após iniciar (para maior segurança)
xhost -local:docker
