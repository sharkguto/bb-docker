#!/bin/bash

# Iniciar o systemd em background
echo "Iniciando systemd..."
sudo /lib/systemd/systemd --system --unit=multi-user.target

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
    # exit 1
fi

# Executar o bootstrap.sh como usuário "ubuntu"
echo "Executando bootstrap.sh como usuário ubuntu..."
#sudo -u ubuntu bash /home/ubuntu/bootstrap.sh

# Verificar se o warsaw já está instalado
if whereis warsaw | grep -q '/'; then
    echo "Warsaw já está instalado em: $(whereis warsaw)"
else
    echo "Warsaw não encontrado. Iniciando a instalação..."

    # Executar o instalador
    sudo ./warsaw_setup64.run

    # Entrar na pasta criada pelo instalador (assumindo que seja 'warsaw_setup')
    if [ -d "warsaw_setup" ]; then
        cd warsaw_setup
        # Instalar o pacote .deb com força
        sudo dpkg --force-all -i warsaw_*.deb
        cd ..
    else
        echo "Erro: Pasta 'warsaw_setup' não encontrada. Verifique o instalador."
        exit 1
    fi
fi

# # Executar o Warsaw
# echo "Executando Warsaw..."
# /usr/local/bin/warsaw/core &

# Manter o container rodando
tail -f /dev/null
