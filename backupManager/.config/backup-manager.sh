#!/usr/bin/env bash
# backup-manager - Gerenciador robusto de snapshots e backups com Btrfs, Snapper e Stow
# Instale em ~/.local/bin/backup-manager e torne executável (chmod +x)

set -euo pipefail

# Cores para saída
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funções de log
log()    { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
success(){ echo -e "${GREEN}[SUCESSO]${NC} $1"; }
warning(){ echo -e "${YELLOW}[AVISO]${NC}  $1"; }
error()  { echo -e "${RED}[ERRO]${NC}   $1" >&2; }

# Verificações básicas
check_root() {
  if [[ $EUID -ne 0 ]]; then error "Esta operação precisa ser executada como root"; exit 1; fi
}
check_btrfs() {
  if ! command -v btrfs &> /dev/null; then error "Btrfs não instalado"; exit 1; fi
  if ! findmnt -t btrfs / &> /dev/null; then error "Raiz não em Btrfs"; exit 1; fi
}
check_snapper() {
  if ! command -v snapper &> /dev/null; then error "Snapper não instalado"; exit 1; fi
  if ! snapper list-configs | grep -qw root; then error "Snapper sem config root"; exit 1; fi
}

# 1. Snapshot manual rápido
snap() {
  if [[ -z "${1:-}" ]]; then
    log "Snapshots recentes:"; sudo snapper -c root list | tail -5; exit 0
  fi
  check_root; check_snapper
  log "Criando snapshot: $1"
  sudo snapper -c root create --description "$1"
  success "Snapshot criado"
}

# 2. Status geral do sistema e backups
status() {
  log "=== STATUS DO SISTEMA DE BACKUP ==="
  echo
  log "Snapshots atuais:"; sudo snapper -c root list | tail -10
  echo
  log "Uso de espaço Btrfs:"; sudo btrfs filesystem usage / | grep -E "Device size|Used|Free"
  echo
  log "Timers Snapper:"; systemctl is-active snapper-timeline.timer && echo "✔ ativo" || echo "✖ inativo"
  systemctl is-active snapper-cleanup.timer && echo "✔ ativo" || echo "✖ inativo"
  echo
  log "Últimas operações do pacman:"; grep -E "installed|upgraded|removed" /var/log/pacman.log | tail -5
}

# 3. Limpeza inteligente
cleanup() {
  check_root; check_snapper
  log "Limpando snapshots antigos..."
  local before=$(sudo snapper -c root list | wc -l)
  sudo snapper -c root cleanup number
  sudo snapper -c root cleanup timeline
  local after=$(sudo snapper -c root list | wc -l)
  success "Limpeza concluída: $((before-after)) snapshots removidos"
}

# 4. Backup completo
full_backup() {
  check_root; check_snapper
  local name="full-$(date +'%Y%m%d-%H%M')"
  log "Backup completo: $name"
  sudo snapper -c root create --description "Backup completo: $name"
  # Dotfiles
  if [[ -d "$HOME/dotfiles" ]]; then
    log "Sincronizando dotfiles"
    (cd "$HOME/dotfiles" && git add . && git commit -m "Backup $name" 2>/dev/null) || log "Sem mudanças nos dotfiles"
    git -C "$HOME/dotfiles" remote &>/dev/null && git -C "$HOME/dotfiles" push && success "Dotfiles enviados"
  fi
  # Externo
  local ext="/mnt/backup"
  if [[ -d "$ext" ]]; then
    local last=$(sudo snapper -c root list | tail -1 | awk '{print $1}')
    sudo btrfs send /.snapshots/$last/snapshot | sudo btrfs receive $ext/
    success "Backup externo criado em $ext"
  fi
  success "Backup completo finalizado"
}

# 5. Restauração interativa
restore() {
  check_root; check_snapper
  log "Snapshots disponíveis:"; sudo snapper -c root list
  read -rp "Número do snapshot: " id
  [[ -z "$id" ]] && error "ID não fornecido" && return 1
  read -rp "Confirma restauração de $id? (s/n): " ok
  [[ "$ok" != "s" ]] && warning "Operação cancelada" && return
  sudo snapper -c root create --description "Antes de restaurar $id"
  sudo snapper -c root rollback $id
  success "Restaurado para snapshot $id. Reinicie o sistema."
}

# 6. Setup inicial do sistema de backup
setup_backup() {
  log "Configuração inicial do Snapper"
  command -v snapper &>/dev/null || sudo pacman -S --noconfirm snapper
  sudo snapper list-configs | grep -qw root || sudo snapper -c root create-config /
  sudo mkdir -p /etc/pacman.d/hooks
  # Hooks pacman
  sudo tee /etc/pacman.d/hooks/00-snapper-pre.hook >/dev/null << 'EOF'
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = PreTransaction snapshot
When = PreTransaction
Exec = /usr/bin/snapper --no-dbus -c root create --description "pacman pre"
EOF
  sudo tee /etc/pacman.d/hooks/01-snapper-post.hook >/dev/null << 'EOF'
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = PostTransaction snapshot
When = PostTransaction
Exec = /usr/bin/snapper --no-dbus -c root create --description "pacman post"
EOF
  sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
  sudo chmod 750 /.snapshots
  sudo snapper -c root create --description "Configuração inicial"
  success "Setup concluído"
}

# 7. Sincronização de dotfiles com Stow
sync_dotfiles() {
  local dir="$HOME/dotfiles"
  [[ -d "$dir" ]] || { error "Dotfiles não encontrados"; return; }
  log "Sincronizando dotfiles com Stow"
  cd "$dir"
  stow -D */ || true
  for d in */; do stow "$d"; done
  if git -C "$dir" diff --quiet; then
    log "Sem mudanças nos dotfiles"
  else
    git -C "$dir" add . && git -C "$dir" commit -m "Stow sync $(date '+%Y-%m-%d %H:%M')"
    git -C "$dir" push && success "Dotfiles commitados"
  fi
}

# Menu principal
menu() {
  echo
  echo "=== BACKUP MANAGER ==="
  echo "1) Snap rápido"
  echo "2) Status do backup"
  echo "3) Limpeza snapshots"
  echo "4) Backup completo"
  echo "5) Restaurar snapshot"
  echo "6) Setup inicial"
  echo "7) Sync dotfiles"
  echo "8) Sair"
  read -rp "Escolha: " opt
  case $opt in
    1) read -rp "Descrição: " d; snap "$d";;
    2) status;;
    3) cleanup;;
    4) full_backup;;
    5) restore;;
    6) setup_backup;;
    7) sync_dotfiles;;
    8) exit 0;;
    *) error "Opção inválida";;
  esac
}

# Execução
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  check_btrfs
  while true; do
    menu
    read -rp "Pressione Enter para continuar..." _
  done
fi

