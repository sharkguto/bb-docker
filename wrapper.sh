#!/bin/bash

# Iniciar o systemd em background
echo "Iniciando systemd..."
/lib/systemd/systemd --system --unit=multi-user.target

# Aguardar até que o systemd esteja pronto (máximo de 60 segundos)
echo "Aguardando systemd inicializar..."
for i in {1..60}; do
    if systemctl is-system-running >/dev/null 2>&1 || systemctl status >/dev/null 2>&1; then
        echo "Systemd iniciado com sucesso."
        break
    fi
    echo "Systemd ainda não está pronto, aguardando... ($i/60)"
    sleep 1
done

# Verificar se o systemd iniciou corretamente
if ! systemctl is-system-running >/dev/null 2>&1 && ! systemctl status >/dev/null 2>&1; then
    echo "Erro: systemd não iniciou corretamente."
    journalctl -xe
    exit 1
fi

# Executar o bootstrap.sh como usuário "ubuntu"
echo "Executando bootstrap.sh como usuário ubuntu..."
sudo -u ubuntu bash /home/ubuntu/bootstrap.sh
