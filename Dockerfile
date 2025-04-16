# Usar Ubuntu 24.04 como base
FROM ubuntu:24.04

# Atualizar repositórios e instalar dependências básicas
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    libcurl4 \
    gnupg \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxcursor1 \
    libxft2 \
    libfontconfig1 \
    libfreetype6 \
    libgtk2.0-0 \
    locales \
    sudo \
    xdotool \
    libasound2t64 libnspr4 libnss3 xdg-utils \
    fonts-liberation libatk-bridge2.0-0 libatspi2.0-0 \
    zenity && rm -rf /var/lib/apt/lists/*

# Configurar locale para evitar problemas com strings
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /home/ubuntu

# Baixar o warsaw_setup64.run
RUN wget https://cloud.gastecnologia.com.br/bb/downloads/ws/debian/warsaw_setup64.run

# Tornar o arquivo executável
RUN chmod +x warsaw_setup64.run

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

RUN dpkg -i ./google-chrome-stable_current_amd64.deb

COPY ./bootstrap.sh /home/ubuntu/bootstrap.sh

RUN usermod -aG sudo ubuntu

# Opcional: Permitir sudo sem senha para o usuário "ubuntu"
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

# Definir o usuário padrão como "ubuntu"
USER ubuntu

ENTRYPOINT [ "bash", "bootstrap.sh" ]
