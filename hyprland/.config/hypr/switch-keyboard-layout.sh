#!/bin/bash

# Obter o layout atual
current_layout=$(hyprctl getoption input:kb_layout | grep -oP "str: \K.*")

# Configurações de layouts disponíveis (usando códigos que o Hyprland reconhece)
layouts=("br" "us")

# Encontrar o índice do layout atual
current_index=-1
for i in "${!layouts[@]}"; do
    if [ "${layouts[$i]}" = "$current_layout" ]; then
        current_index=$i
        break
    fi
done

# Se o layout atual não for encontrado ou for o último da lista, mudar para o primeiro
# Caso contrário, mudar para o próximo layout na lista
if [ $current_index -eq -1 ] || [ $current_index -eq $((${#layouts[@]} - 1)) ]; then
    next_layout=${layouts[0]}
else
    next_layout=${layouts[$((current_index + 1))]}
fi

# Aplicar o novo layout
hyprctl keyword input:kb_layout "$next_layout"

# Mostrar nome amigável na notificação
case "$next_layout" in
    "br") display_name="pt-br" ;;
    "us") display_name="us" ;;
    *) display_name="$next_layout" ;;
esac

notify-send "Teclado" "Layout alterado para: $display_name" -i input-keyboard -t 2000

# Notificar a mudança com notify-send
notify-send "Teclado" "Layout alterado para: $next_layout" -i input-keyboard -t 2000
