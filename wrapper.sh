#!/bin/bash

# Aguardar até que o systemd esteja pronto
echo "Aguardando systemd inicializar..."
for i in {1..60}; do
    if systemctl is-system-running >/dev/null 2>&1; then
        echo "Systemd iniciado com sucesso."
        break
    fi
    echo "Systemd ainda não está pronto, aguardando... ($i/60)"
    sleep 1
done

# Verificar se o systemd iniciou corretamente
if ! systemctl is-system-running >/dev/null 2>&1; then
    echo "Erro: systemd não iniciou corretamente."
    journalctl -xe
    exit 1
fi

# Verificar se o DISPLAY está configurado
if [ -z "$DISPLAY" ]; then
    echo "Erro: Variável DISPLAY não está definida."
    exit 1
fi

# Executar o bootstrap.sh como usuário "ubuntu"
echo "Executando bootstrap.sh..."
sudo -u ubuntu bash /home/ubuntu/bootstrap.sh

# Verificar se o Warsaw já está instalado
if whereis warsaw | grep -q '/'; then
    echo "Warsaw já está instalado em: $(whereis warsaw)"
else
    echo "Warsaw não encontrado. Iniciando a instalação..."
    cd /home/ubuntu
    sudo -u ubuntu ./warsaw_setup64.run
    if [ -d "warsaw_setup" ]; then
        cd warsaw_setup
        sudo dpkg --force-all -i warsaw_*.deb
        cd ..
    else
        echo "Erro: Pasta 'warsaw_setup' não encontrada."
        exit 1
    fi
fi

# Criar um serviço systemd para o Warsaw (se necessário)
if ! systemctl is-enabled warsaw >/dev/null 2>&1; then
    echo "Criando serviço systemd para o Warsaw..."
    cat <<EOF >/etc/systemd/system/warsaw.service
[Unit]
Description=Warsaw Core Service
After=network.target

[Service]
ExecStart=/usr/local/bin/warsaw/core
Restart=always
User=ubuntu

[Install]
WantedBy=multi-user.target
EOF
    systemctl enable warsaw
    systemctl start warsaw
fi

# Verificar o status do serviço Warsaw
systemctl status warsaw