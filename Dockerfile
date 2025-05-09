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
    dbus \
    dbus-x11 \
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

# Desativar serviços desnecessários
RUN systemctl disable systemd-resolved systemd-timesyncd

# Baixar e configurar o instalador do Warsaw
WORKDIR /home/ubuntu
RUN wget https://cloud.gastecnologia.com.br/bb/downloads/ws/debian/warsaw_setup64.run \
    && chmod +x warsaw_setup64.run \
    && chown ubuntu:ubuntu warsaw_setup64.run

# # Executar o instalador do Warsaw
# RUN ./warsaw_setup64.run --install \
#     && rm warsaw_setup64.run

# Copiar scripts
COPY wrapper.sh /wrapper.sh
COPY bootstrap.sh /home/ubuntu/bootstrap.sh
RUN chmod +x /wrapper.sh /home/ubuntu/bootstrap.sh \
    && chown ubuntu:ubuntu /home/ubuntu/bootstrap.sh

# Copiar o serviço Warsaw
#COPY warsaw.service /etc/systemd/system/warsaw.service
#RUN systemctl enable warsaw.service

# Criar serviço systemd para executar o wrapper.sh
RUN echo '[Unit]\n\
Description=Execute wrapper.sh\n\
After=network.target\n\
\n\
[Service]\n\
Type=oneshot\n\
ExecStart=/wrapper.sh\n\
RemainAfterExit=yes\n\
User=ubuntu\n\
\n\
[Install]\n\
WantedBy=multi-user.target' > /etc/systemd/system/wrapper.service \
    && systemctl enable wrapper.service

# Configurar o D-Bus
RUN mkdir -p /run/dbus /run/user/1000 \
    && dbus-uuidgen > /var/lib/dbus/machine-id \
    && chown ubuntu:ubuntu /run/user/1000

# Configurar o systemd como entrypoint
ENTRYPOINT ["/sbin/init"]