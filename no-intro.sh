#!/usr/bin/env bash
set -euo pipefail

# Colours (disabled if not a tty)
if [[ -t 1 ]]; then
    BOLD='\033[1m'; DIM='\033[2m'; CYAN='\033[36m'; GREEN='\033[32m'
    YELLOW='\033[33m'; MAGENTA='\033[35m'; RESET='\033[0m'
    CHECK="*"; ARROW="->"; DOT="-"
else
    BOLD=''; DIM=''; CYAN=''; GREEN=''; YELLOW=''; MAGENTA=''; RESET=''
    CHECK="[ok]"; ARROW="->"; DOT="-"
fi

info()  { echo -e "  ${CYAN}${DOT}${RESET} $*"; }
ok()    { echo -e "  ${GREEN}${CHECK}${RESET} $*"; }
warn()  { echo -e "  ${YELLOW}!${RESET}  $*"; }
add()   { echo -e "  ${MAGENTA}+${RESET} $*"; }
skip()  { echo -e "  ${DIM}${DOT} $* (already set)${RESET}"; }

box() {
    local title="$1" subtitle="$2"
    local max
    if (( ${#title} > ${#subtitle} )); then max=${#title}; else max=${#subtitle}; fi
    local pad_val=2
    local inner=$((max + pad_val*2))
    local top bot
    top="+$(printf -- '-%.0s' $(seq 1 $inner))+"
    bot="+$(printf -- '-%.0s' $(seq 1 $inner))+"
    echo ""
    echo -e "${BOLD}${CYAN}  $top${RESET}"
    local left=$(( (inner - ${#title}) / 2 ))
    local right=$(( inner - ${#title} - left ))
    printf "  ${BOLD}${CYAN}|${RESET}%${left}s${BOLD}%s${RESET}%${right}s${BOLD}${CYAN}|${RESET}\n" "" "$title" ""
    left=$(( (inner - ${#subtitle}) / 2 ))
    right=$(( inner - ${#subtitle} - left ))
    printf "  ${BOLD}${CYAN}|${RESET}%${left}s${DIM}%s${RESET}%${right}s${BOLD}${CYAN}|${RESET}\n" "" "$subtitle" ""
    echo -e "${BOLD}${CYAN}  $bot${RESET}"
    echo -e "  ${DIM}  by SavageCore  -  v0.0.0${RESET}"
    echo ""
}
box "Abiotic Factor - No-Intro" "Skip startup/splash videos"

folder_path="$HOME/.local/share/Steam/steamapps/compatdata/427410/pfx/drive_c/users/steamuser/AppData/Local/AbioticFactor/Saved/Config/Windows"
ini_file="$folder_path/Game.ini"

mkdir -p "$folder_path"

if [[ ! -f "$ini_file" ]]; then
    echo "; Configuration File" > "$ini_file"
    ok "Created ${BOLD}Game.ini${RESET}"
fi

echo ""
echo -e "  ${BOLD}Patching MoviePlayer settings${RESET} ${DIM}--${RESET}"

ensure_section() {
    if grep -qE '^\[/Script/MoviePlayer\.MoviePlayerSettings\]' "$ini_file" 2>/dev/null; then
        skip "Section"
    else
        echo '[/Script/MoviePlayer.MoviePlayerSettings]' >> "$ini_file"
        add "Section ${DIM}${ARROW} ${RESET}${GREEN}[/Script/MoviePlayer.MoviePlayerSettings]${RESET}"
    fi
}

ensure_value() {
    local key="$1" want="$2"
    local line="${key}=${want}"
    if grep -qFx "$line" "$ini_file" 2>/dev/null; then
        skip "$key"
    elif grep -qE "^${key}=" "$ini_file" 2>/dev/null; then
        chmod u+w "$ini_file"
        sed -i "s|^${key}=.*|${line}|" "$ini_file"
        add "$key ${DIM}${ARROW} ${RESET}${GREEN}$line${RESET} ${YELLOW}(corrected)${RESET}"
    else
        echo "$line" >> "$ini_file"
        add "$key ${DIM}${ARROW} ${RESET}${GREEN}$line${RESET}"
    fi
}

ensure_section
ensure_value 'bWaitForMoviesToComplete' 'False'
ensure_value 'bMoviesAreSkippable' 'True'
ensure_value 'StartupMovies' ''

chmod a-w "$ini_file"

echo ""
echo -e "  ${GREEN}${BOLD}Done!${RESET} ${DIM}- Game.ini is updated and read-only.${RESET}"
echo ""
