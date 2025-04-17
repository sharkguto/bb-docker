# Usar Ubuntu 24.04 como base
FROM ubuntu:24.04

# Atualizar repositórios e instalar dependências
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
    libasound2t64 \
    libnspr4 \
    libnss3 \
    xdg-utils \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    zenity \
    systemd \
    systemd-sysv \
    && rm -rf /var/lib/apt/lists/*

# Configurar locale
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Instalar o Google Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -f -y \
    && rm google-chrome-stable_current_amd64.deb

# Criar usuário "ubuntu" com UID 1000
RUN usermod -aG sudo ubuntu \
    && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Desativar serviços desnecessários (opcional)
RUN systemctl disable systemd-resolved systemd-timesyncd

# Baixar e configurar o instalador do Warsaw
WORKDIR /home/ubuntu
RUN wget https://cloud.gastecnologia.com.br/bb/downloads/ws/debian/warsaw_setup64.run \
    && chmod +x warsaw_setup64.run \
    && chown ubuntu:ubuntu warsaw_setup64.run

# Copiar scripts
COPY wrapper.sh /wrapper.sh
COPY bootstrap.sh /home/ubuntu/bootstrap.sh
RUN chmod +x /wrapper.sh /home/ubuntu/bootstrap.sh \
    && chown ubuntu:ubuntu /home/ubuntu/bootstrap.sh

# Configurar o systemd como entrypoint
ENTRYPOINT ["/sbin/init"]