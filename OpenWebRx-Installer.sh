#!/bin/bash
#
# OpenWebRx-Installer — Install OpenWebRX + RTL-SDR on Debian/Ubuntu
#
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log()   { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }

# Must be run as root or with sudo
if [[ $EUID -ne 0 ]]; then
    error "Dit script moet worden uitgevoerd met sudo of als root."
fi

# Detect distro
if command -v apt-get &>/dev/null; then
    DISTRO="debian"
    INSTALL="apt-get install -y"
elif command -v dnf &>/dev/null; then
    DISTRO="fedora"
    INSTALL="dnf install -y"
else
    error "Onbekende distro. Alleen Debian/Ubuntu en Fedora/RHEL worden ondersteund."
fi

log "Distro gedetecteerd: $DISTRO"

# Install dependencies
log "Installeren van dependencies..."
if [[ "$DISTRO" == "debian" ]]; then
    apt-get update -qq
    $INSTALL build-essential git libfftw3-dev cmake libusb-1.0-0-dev nmap
else
    $INSTALL gcc gcc-c++ git make cmake fftw-devel libusb1-devel nmap
fi

# Clone and build rtl-sdr
if [[ ! -d rtl-sdr ]]; then
    log "Clonen van rtl-sdr..."
    git clone git://git.osmocom.org/rtl-sdr.git
fi

cd rtl-sdr
mkdir -p build
cd build
log "Compileren van rtl-sdr..."
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j$(nproc)
sudo make install
sudo ldconfig
cd ../..

# Disable DVB-T driver
log "DVB-T driver uitschakelen..."
sudo bash -c 'echo -e "\n# for RTL-SDR:\nblacklist dvb_usb_rtl28xxu\n" >> /etc/modprobe.d/blacklist.conf'
sudo rmmod dvb_usb_rtl28xxu 2>/dev/null || warn "Kon dvb_usb_rtl28xxu niet verwijderen (mogelijk niet geladen)"

# Clone OpenWebRX and libcsdr
if [[ ! -d openwebrx ]]; then
    log "Clonen van OpenWebRX..."
    git clone https://github.com/simonyiszk/openwebrx.git
fi

if [[ ! -d csdr ]]; then
    log "Clonen van libcsdr..."
    git clone https://github.com/simonyiszk/csdr.git
fi

# Compile libcsdr
cd csdr
log "Compileren van libcsdr..."
make -j$(nproc)
sudo make install
cd ..

# Edit config
log "OpenWebRX configureren..."
if [[ -f openwebrx/config_webrx.py ]]; then
    ${EDITOR:-nano} openwebrx/config_webrx.py
else
    warn "config_webrx.py niet gevonden in openwebrx/"
fi

# Run OpenWebRX
log "Starten van OpenWebRX..."
cd openwebrx
./openwebrx.py
