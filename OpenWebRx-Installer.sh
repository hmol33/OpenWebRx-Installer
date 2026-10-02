#!/bin/bash
set -euo pipefail

# OpenWebRx-Installer: installeert OpenWebRX met RTL-SDR ondersteuning
# Gebruik: bash OpenWebRx-Installer.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential git libfftw3-dev cmake libusb-1.0-0-dev nmap
# nmap is nodig voor ncat (netcat alternatief gebruikt door OpenWebRX)

# Fetch and build rtl-sdr
if [ ! -d rtl-sdr ]; then
  git clone https://git.osmocom.org/rtl-sdr.git
fi
cd rtl-sdr
mkdir -p build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make -j$(nproc)
sudo make install
sudo ldconfig
cd ../..

# Disable DVB-T driver (voorkomt conflicten met RTL-SDR)
sudo bash -c 'echo -e "\n# for RTL-SDR:\nblacklist dvb_usb_rtl28xxu\n" >> /etc/modprobe.d/blacklist.conf'
sudo rmmod dvb_usb_rtl28xxu 2>/dev/null || true

# Download OpenWebRX and libcsdr
if [ ! -d openwebrx ]; then
  git clone https://github.com/simonyiszk/openwebrx.git
fi
if [ ! -d csdr ]; then
  git clone https://github.com/simonyiszk/csdr.git
fi

# Compile libcsdr
cd csdr
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..

# Edit OpenWebRX config (optioneel)
if command -v nano >/dev/null 2>&1; then
  nano openwebrx/config_webrx.py
fi

# Start OpenWebRX
cd openwebrx
echo "OpenWebRX wordt gestart. Open http://localhost:8073 in je browser."
echo "Ctrl+C om te stoppen."
./openwebrx.py
