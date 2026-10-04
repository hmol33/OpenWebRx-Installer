#!/bin/bash
set -euo pipefail

# OpenWebRx-Installer — Verbeterde versie
# Installert OpenWebRx + RTL-SDR op Debian/Ubuntu

# ─── Configuratie ──────────────────────────────────────────────────────────────
DRY_RUN="${DRY_RUN:-}"
LOG_FILE="${LOG_FILE:-/tmp/openwebrx-installer.log}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/openwebrx-install}"

# ─── Logging ──────────────────────────────────────────────────────────────────
log() {
    local level="$1"
    shift
    local msg
    msg="[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*"
    echo "$msg"
    echo "$msg" >> "$LOG_FILE" 2>/dev/null || true
}

info()  { log "INFO" "$@"; }
warn()  { log "WARN" "$@"; }
error() { log "ERROR" "$@"; }

# ─── DRY_RUN helper ───────────────────────────────────────────────────────────
run() {
    if [ -n "$DRY_RUN" ]; then
        info "[DRY-RUN] Would run: $*"
        return 0
    fi
    "$@"
}

# ─── Dependency check ─────────────────────────────────────────────────────────
check_dependencies() {
    local deps=("git" "cmake" "make" "gcc" "g++" "nano" "wget" "curl")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        error "Ontbrekende dependencies: ${missing[*]}"
        info "Installeer met: sudo apt-get install ${missing[*]}"
        exit 1
    fi
    
    info "Alle dependencies aanwezig"
}

# ─── Error handler ────────────────────────────────────────────────────────────
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        error "Installatie mislukt met exit code $exit_code"
        error "Bekijk log: $LOG_FILE"
    fi
    exit $exit_code
}
trap cleanup EXIT

# ─── Hoofdinstallatie ─────────────────────────────────────────────────────────
main() {
    info "=== OpenWebRx Installer gestart ==="
    info "Installatie directory: $INSTALL_DIR"
    info "Log bestand: $LOG_FILE"
    
    if [ -n "$DRY_RUN" ]; then
        info "DRY-RUN mode — er worden geen wijzigingen aangebracht"
    fi
    
    check_dependencies
    
    # Stap 1: Installeer systeem dependencies
    info "Stap 1/6: Systeem dependencies installeren"
    run sudo apt-get update -qq
    run sudo apt-get install -y -qq build-essential git libfftw3-dev cmake libusb-1.0-0-dev nmap
    
    # Stap 2: Maak installatie directory
    info "Stap 2/6: Installatie directory voorbereiden"
    if [ ! -d "$INSTALL_DIR" ]; then
        run mkdir -p "$INSTALL_DIR"
    fi
    cd "$INSTALL_DIR"
    
    # Stap 3: Clone en bouw rtl-sdr
    info "Stap 3/6: RTL-SDR bouwen"
    if [ ! -d "rtl-sdr" ]; then
        run git clone https://git.osmocom.org/rtl-sdr.git
    fi
    cd rtl-sdr
    if [ ! -d "build" ]; then
        run mkdir build
    fi
    cd build
    run cmake ../ -DINSTALL_UDEV_RULES=ON
    run make -j"$(nproc)"
    run sudo make install
    run sudo ldconfig
    cd "$INSTALL_DIR"
    
    # Stap 4: Disable DVB-T driver
    info "Stap 4/6: DVB-T driver uitschakelen"
    if ! grep -q "blacklist dvb_usb_rtl28xxu" /etc/modprobe.d/blacklist.conf 2>/dev/null; then
        run sudo bash -c 'echo -e "\n# for RTL-SDR:\nblacklist dvb_usb_rtl28xxu\n" >> /etc/modprobe.d/blacklist.conf'
    fi
    run sudo rmmod dvb_usb_rtl28xxu 2>/dev/null || warn "Kon dvb_usb_rtl28xxu niet verwijderen (mogelijk al niet geladen)"
    
    # Stap 5: Clone en bouw OpenWebRX + libcsdr
    info "Stap 5/6: OpenWebRX en libcsdr bouwen"
    if [ ! -d "openwebrx" ]; then
        run git clone https://github.com/simonyiszk/openwebrx.git
    fi
    if [ ! -d "csdr" ]; then
        run git clone https://github.com/simonyiszk/csdr.git
    fi
    cd csdr
    run make -j"$(nproc)"
    run sudo make install
    run sudo ldconfig
    cd "$INSTALL_DIR"
    
    # Stap 6: Configuratie en start
    info "Stap 6/6: Configuratie"
    info "OpenWebRx is geïnstalleerd in $INSTALL_DIR/openwebrx"
    info "Start met: cd $INSTALL_DIR/openwebrx && ./openwebrx.py"
    
    if [ -z "$DRY_RUN" ]; then
        info "Wil je de config nu bewerken? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            run nano "$INSTALL_DIR/openwebrx/config_webrx.py"
        fi
        
        info "Start OpenWebRx nu? (y/n)"
        read -r answer
        if [ "$answer" = "y" ]; then
            cd "$INSTALL_DIR/openwebrx"
            exec ./openwebrx.py
        fi
    fi
    
    info "=== Installatie voltooid ==="
    info "OpenWebRx directory: $INSTALL_DIR/openwebrx"
    info "Start met: cd $INSTALL_DIR/openwebrx && ./openwebrx.py"
}

main "$@"
