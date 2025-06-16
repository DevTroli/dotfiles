#!/usr/bin/env bash

# Função para verificar se o bluetooth está disponível
bluetooth_status() {
    if systemctl is-active bluetooth >/dev/null 2>&1; then
        bluetooth_powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
        if [ "$bluetooth_powered" = "yes" ]; then
            echo "enabled"
        else
            echo "disabled"
        fi
    else
        echo "disabled"
    fi
}

# Função para obter a lista de dispositivos bluetooth
get_bluetooth_devices() {
    paired_devices=$(bluetoothctl devices | cut -d ' ' -f 2- | sed 's/Device //')
    available_devices=$(bluetoothctl scan on & sleep 5; killall -SIGINT bluetoothctl 2>/dev/null; bluetoothctl devices | cut -d ' ' -f 2- | sed 's/Device //')
    
    echo "$available_devices" | sort | uniq
}

# Verifica se dispositivo está conectado
is_connected() {
    device=$1
    status=$(bluetoothctl info "$device" | grep "Connected:" | awk '{print $2}')
    if [ "$status" = "yes" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Formatar lista para o Rofi
format_device_list() {
    devices_list=""
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            mac=$(echo "$line" | cut -d ' ' -f 1)
            name=$(echo "$line" | cut -d ' ' -f 2-)
            
            if [ "$(is_connected "$mac")" = "true" ]; then
                devices_list="${devices_list}  Connected: $name ($mac)\n"
            else
                devices_list="${devices_list}  $name ($mac)\n"
            fi
        fi
    done <<< "$1"
    echo -e "$devices_list"
}

# Conectar ao dispositivo selecionado
connect_to_device() {
    device_mac=$1
    notify-send "Bluetooth" "Tentando conectar ao dispositivo..."
    
    if bluetoothctl connect "$device_mac" | grep "Connection successful"; then
        notify-send "Bluetooth" "Conectado com sucesso!"
    else
        notify-send "Bluetooth" "Falha na conexão. Tente parear o dispositivo primeiro."
    fi
}

# Desconectar do dispositivo
disconnect_device() {
    device_mac=$1
    bluetoothctl disconnect "$device_mac"
    notify-send "Bluetooth" "Dispositivo desconectado"
}

# Parear com novo dispositivo
pair_device() {
    device_mac=$1
    notify-send "Bluetooth" "Tentando parear com o dispositivo..."
    
    if bluetoothctl pair "$device_mac" | grep "Pairing successful"; then
        notify-send "Bluetooth" "Pareamento bem-sucedido!"
        connect_to_device "$device_mac"
    else
        notify-send "Bluetooth" "Falha no pareamento."
    fi
}

# Verificar status do bluetooth
status=$(bluetooth_status)

# Configurar opções de toggle baseado no status
if [[ "$status" =~ "enabled" ]]; then
    toggle="  Desativar Bluetooth"
    # Obter lista de dispositivos
    device_list=$(get_bluetooth_devices)
    formatted_devices=$(format_device_list "$device_list")
else
    toggle="  Ativar Bluetooth"
    formatted_devices=""
fi

# Configurar opções adicionais
options="$toggle\n  Procurar Dispositivos\n$formatted_devices"

# Exibir menu no Rofi
chosen_option=$(echo -e "$options" | rofi -dmenu -i -p "Bluetooth: ")

# Processar a escolha
if [ -z "$chosen_option" ]; then
    exit 0
elif [ "$chosen_option" = "  Ativar Bluetooth" ]; then
    systemctl start bluetooth
    bluetoothctl power on
    notify-send "Bluetooth" "Bluetooth ativado"
elif [ "$chosen_option" = "  Desativar Bluetooth" ]; then
    bluetoothctl power off
    notify-send "Bluetooth" "Bluetooth desativado"
elif [ "$chosen_option" = "  Procurar Dispositivos" ]; then
    notify-send "Bluetooth" "Procurando dispositivos próximos..."
    
    # Executar o script novamente após uma busca
    bluetoothctl scan on &
    sleep 5
    killall -SIGINT bluetoothctl 2>/dev/null
    exec "$0"
else
    # Extrair o MAC do dispositivo selecionado
    device_info=$(echo "$chosen_option" | sed 's/.*(\(.*\))/\1/')
    
    # Verificar se estamos conectando ou desconectando
    if [[ "$chosen_option" == *"Connected:"* ]]; then
        disconnect_device "$device_info"
    else
        # Tentar conectar primeiro, se falhar, tenta parear
        connect_to_device "$device_info"
    fi
fi
