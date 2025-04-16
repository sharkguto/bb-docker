# Usar Ubuntu 18.04 como base
FROM ubuntu:18.04

# Atualizar repositórios e instalar dependências básicas
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    libcurl3 \
    gnupg \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxcursor1 \
    firefox \
    libxft2 \
    && rm -rf /var/lib/apt/lists/*

# Baixar o warsaw_setup64.run
RUN wget https://cloud.gastecnologia.com.br/bb/downloads/ws/debian/warsaw_setup64.run

# Tornar o arquivo executável
RUN chmod +x warsaw_setup64.run