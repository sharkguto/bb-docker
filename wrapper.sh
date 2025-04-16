#!/bin/bash

# Iniciar o systemd em background
/sbin/init &

# Aguardar até que o systemd esteja pronto
while ! systemctl is-system-running >/dev/null 2>&1; do
    sleep 1
done

# Executar o bootstrap.sh como usuário "ubuntu"
sudo -u ubuntu bash /home/ubuntu/bootstrap.sh

# Manter o container ativo
exec tail -f /dev/null