#!/bin/bash

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

# Executar o Warsaw
echo "Executando Warsaw..."
/usr/local/bin/warsaw/core &

# Manter o container rodando
tail -f /dev/null
