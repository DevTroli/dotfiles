#!/bin/bash

# Definindo cores Catppuccin Mocha
declare -A colors=(
    [rosewater]="\033[38;2;245;224;220m"
    [flamingo]="\033[38;2;242;205;205m"
    [pink]="\033[38;2;245;194;231m"
    [mauve]="\033[38;2;203;166;247m"
    [red]="\033[38;2;243;139;168m"
    [maroon]="\033[38;2;235;160;172m"
    [peach]="\033[38;2;250;179;135m"
    [yellow]="\033[38;2;249;226;175m"
    [green]="\033[38;2;166;227;161m"
    [teal]="\033[38;2;148;226;213m"
    [sky]="\033[38;2;137;220;235m"
    [sapphire]="\033[38;2;116;199;236m"
    [blue]="\033[38;2;137;180;250m"
    [lavender]="\033[38;2;180;190;254m"
    [text]="\033[38;2;205;214;244m"
    [subtext1]="\033[38;2;186;194;222m"
    [subtext0]="\033[38;2;166;173;200m"
    [overlay2]="\033[38;2;147;153;178m"
    [overlay1]="\033[38;2;127;132;156m"
    [overlay0]="\033[38;2;108;112;134m"
    [surface2]="\033[38;2;88;91;112m"
    [surface1]="\033[38;2;69;71;90m"
    [surface0]="\033[38;2;49;50;68m"
    [base]="\033[38;2;30;30;46m"
    [mantle]="\033[38;2;24;24;37m"
    [crust]="\033[38;2;17;17;27m"
    [reset]="\033[0m"
)

# Cores numeradas para gradiente
declare -a gradient_colors=(
    "${colors[red]}"
    "${colors[peach]}"
    "${colors[yellow]}"
    "${colors[green]}"
    "${colors[teal]}"
    "${colors[sky]}"
    "${colors[sapphire]}"
    "${colors[blue]}"
    "${colors[lavender]}"
    "${colors[pink]}"
    "${colors[mauve]}"
)

# Funções de cor
color() { echo -ne "${colors[$1]}"; }
reset_color() { echo -ne "${colors[reset]}"; }
gradient_color() { echo -ne "${gradient_colors[$1]}"; }

# Função para obter informações do sistema
get_system_info() {
    # Info básica
    user_info="$(whoami)@$(hostname)"
    
    # OS/Distro
    if [[ -f /etc/os-release ]]; then
        distro=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2- | tr -d '"' | sed 's/Linux//' | xargs)
    else
        distro=$(uname -s)
    fi
    
    # Kernel
    kernel=$(uname -r)
    
    # Uptime
    uptime_seconds=$(cat /proc/uptime | cut -d' ' -f1 | cut -d'.' -f1)
    uptime_days=$((uptime_seconds / 86400))
    uptime_hours=$(((uptime_seconds % 86400) / 3600))
    uptime_minutes=$(((uptime_seconds % 3600) / 60))
    
    if [[ $uptime_days -gt 0 ]]; then
        uptime="${uptime_days}d ${uptime_hours}h ${uptime_minutes}m"
    elif [[ $uptime_hours -gt 0 ]]; then
        uptime="${uptime_hours}h ${uptime_minutes}m"
    else
        uptime="${uptime_minutes}m"
    fi
    
    # Desktop Environment / Window Manager
    if [[ -n "$XDG_CURRENT_DESKTOP" ]]; then
        de="$XDG_CURRENT_DESKTOP"
    elif [[ -n "$DESKTOP_SESSION" ]]; then
        de="$DESKTOP_SESSION"
    elif pgrep -x "hyprland" > /dev/null; then
        de="Hyprland"
    elif pgrep -x "i3" > /dev/null; then
        de="i3"
    elif pgrep -x "sway" > /dev/null; then
        de="Sway"
    elif pgrep -x "bspwm" > /dev/null; then
        de="bspwm"
    elif pgrep -x "dwm" > /dev/null; then
        de="dwm"
    else
        de="Unknown"
    fi
    
    # CPU com porcentagem de uso
    cpu_model=$(grep -m1 'model name' /proc/cpuinfo | cut -d ':' -f2 | sed 's/^ *//' | sed 's/(R)//g' | sed 's/(TM)//g' | sed 's/CPU//g' | xargs)
    
    # Calcular uso da CPU (média dos últimos 3 segundos para maior precisão)
    cpu_usage=$(top -bn2 -d1 | grep "Cpu(s)" | tail -1 | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')
    cpu_usage_rounded=$(printf "%.0f" "$cpu_usage")
    
    # GPU
    if command -v lspci > /dev/null; then
        gpu=$(lspci | grep -E "VGA|3D|Display" | cut -d: -f3 | sed 's/^ *//' | head -1)
        # Limpar nome da GPU
        gpu=$(echo "$gpu" | sed 's/\[.*\]//g' | sed 's/Corporation//g' | sed 's/Technologies Inc//g' | xargs)
    else
        gpu="Unknown"
    fi
    
    # Memory
    memory_info=$(free -m)
    memory_used=$(echo "$memory_info" | awk 'NR==2{print $3}')
    memory_total=$(echo "$memory_info" | awk 'NR==2{print $2}')
    memory_percent=$(awk "BEGIN {printf \"%.0f\", $memory_used*100/$memory_total}")
    memory="${memory_used}MB / ${memory_total}MB (${memory_percent}%)"
    
    # Packages
    if command -v pacman > /dev/null; then
        packages=$(pacman -Q 2>/dev/null | wc -l)
        pkg_manager="pacman"
    elif command -v dpkg > /dev/null; then
        packages=$(dpkg -l 2>/dev/null | grep '^ii' | wc -l)
        pkg_manager="dpkg"
    elif command -v rpm > /dev/null; then
        packages=$(rpm -qa 2>/dev/null | wc -l)
        pkg_manager="rpm"
    elif command -v xbps-query > /dev/null; then
        packages=$(xbps-query -l 2>/dev/null | wc -l)
        pkg_manager="xbps"
    else
        packages="Unknown"
        pkg_manager=""
    fi
    
    # Shell
    shell_name=$(basename "$SHELL")
    shell_version=""
    case "$shell_name" in
        "bash") shell_version=$(bash --version | head -1 | cut -d' ' -f4 | cut -d'(' -f1) ;;
        "zsh") shell_version=$(zsh --version | cut -d' ' -f2) ;;
        "fish") shell_version=$(fish --version | cut -d' ' -f3) ;;
    esac
    
    # Terminal
    if [[ -n "$TERM_PROGRAM" ]]; then
        terminal="$TERM_PROGRAM"
    elif [[ -n "$KITTY_WINDOW_ID" ]]; then
        terminal="kitty"
    elif [[ -n "$ALACRITTY_SOCKET" ]]; then
        terminal="alacritty"
    elif [[ "$TERM" == *"tmux"* ]]; then
        terminal="tmux"
    else
        terminal="$TERM"
    fi
    
    # Local IP
    if command -v ip > /dev/null; then
        local_ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' | head -1)
    elif command -v hostname > /dev/null; then
        local_ip=$(hostname -I | awk '{print $1}')
    else
        local_ip="Unknown"
    fi
    
    # Disk
    disk_info=$(df -h / 2>/dev/null | awk 'NR==2{print $3 " / " $2 " (" $5 ")"}')
}

# Função para criar a barra de cores gradiente
create_color_bar() {
    local bar=""
    for i in {0..10}; do
        bar+="$(gradient_color $i)████$(reset_color)"
    done
    echo "$bar"
}

# ASCII Art do Arch Linux com 14 linhas
get_arch_ascii() {
    echo -e "$(color blue)        /\\        $(reset_color)"
    echo -e "$(color blue)       /  \\       $(reset_color)"
    echo -e "$(color blue)      /    \\      $(reset_color)"
    echo -e "$(color blue)     /      \\     $(reset_color)"
    echo -e "$(color blue)    /   /\\   \\    $(reset_color)"
    echo -e "$(color blue)   /   /  \\   \\   $(reset_color)"
    echo -e "$(color blue)  /   /    \\   \\  $(reset_color)"
    echo -e "$(color blue) /   /      \\   \\ $(reset_color)"
    echo -e "$(color blue)/___/        \\___\\$(reset_color)"
    echo -e "$(color blue)\\   \\        /   /$(reset_color)"
    echo -e "$(color blue) \\   \\      /   / $(reset_color)"
    echo -e "$(color blue)  \\   \\____/   /  $(reset_color)"
    echo -e "$(color blue)   \\          /   $(reset_color)"
    echo -e "$(color blue)    \\________/    $(reset_color)"
}

# Função principal para exibir informações lado a lado
display_info() {
    # Preparar as linhas do ASCII art do Arch Linux (14 linhas)
    local ascii_lines=(
        "$(color blue)        /\\        $(reset_color)"
        "$(color blue)       /  \\       $(reset_color)"
        "$(color blue)      /    \\      $(reset_color)"
        "$(color blue)     /      \\     $(reset_color)"
        "$(color blue)    /   /\\   \\    $(reset_color)"
        "$(color blue)   /   /  \\   \\   $(reset_color)"
        "$(color blue)  /   /    \\   \\  $(reset_color)"
        "$(color blue) /   /      \\   \\ $(reset_color)"
        "$(color blue)/___/        \\___\\$(reset_color)"
        "$(color blue)\\   \\        /   /$(reset_color)"
        "$(color blue) \\   \\      /   / $(reset_color)"
        "$(color blue)  \\   \\____/   /  $(reset_color)"
        "$(color blue)   \\          /   $(reset_color)"
        "$(color blue)    \\________/    $(reset_color)"
    )
    
    # Preparar as linhas de informação do sistema
    local info_lines=(
        "$(color mauve) 󰍛 System Info$(reset_color)"
        "$(color overlay0)├─ $(color blue)󰣇 OS$(reset_color)         $distro"
        "$(color overlay0)├─ $(color green)󰌽 Kernel$(reset_color)     $kernel"
        "$(color overlay0)├─ $(color yellow)󰧨 DE/WM$(reset_color)      $de"
        "$(color overlay0)├─ $(color red)󰻠 CPU$(reset_color)        $cpu_model"
        "$(color overlay0)├─ $(color pink)󰢮 GPU$(reset_color)        $gpu"
        "$(color overlay0)├─ $(color teal)󰑭 Memory$(reset_color)     $memory"
        "$(color overlay0)├─ $(color peach)󰔟 Uptime$(reset_color)     $uptime"
        "$(color overlay0)├─ $(color sapphire)󰆍 Shell$(reset_color)      $shell_name $shell_version"
        "$(color overlay0)├─ $(color lavender)󰆍 Terminal$(reset_color)   $terminal"
        "$(color overlay0)├─ $(color sky)󰏖 Packages$(reset_color)   $packages $pkg_manager"
        "$(color overlay0)├─ $(color mauve)󰀂 Local IP$(reset_color)   $local_ip"
        "$(color overlay0)└─ $(color flamingo)󰋊 Disk$(reset_color)       $disk_info"
        "$(color overlay0)└$(create_color_bar)$(reset_color)"
    )
    
    echo
    # Exibir as linhas lado a lado
    for i in {0..14}; do
        printf "%-30s %s\n" "${ascii_lines[$i]}" "${info_lines[$i]}"
    done
    echo
}

# Função principal
main() {
    get_system_info
    display_info
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
