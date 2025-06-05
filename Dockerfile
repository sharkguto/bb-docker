FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
    systemd \
    locales \
    sudo \
    wget \
    gnupg2 \
    libx11-xcb1 libxcb-dri3-0 libdrm2 libgtk-3-0 \
    libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libnss3 \
    libatk1.0-0 libatk-bridge2.0-0 libcups2 libxrandr2 libgbm1 \
    libpango-1.0-0 libcairo2 libasound2t64 libxss1 \
    libappindicator3-1 fonts-liberation xdg-utils curl && \
    locale-gen en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Adiciona repositório do Google Chrome
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cria usuário normal
RUN useradd -ms /bin/bash user && usermod -aG sudo user

USER user
WORKDIR /home/user

CMD ["google-chrome", "--no-sandbox"]
