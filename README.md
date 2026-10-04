# OpenWebRx-Installer

[![CI](https://github.com/hmol33/OpenWebRx-Installer/actions/workflows/ci.yml/badge.svg)](https://github.com/hmol33/OpenWebRx-Installer/actions)
[![Stars](https://img.shields.io/github/stars/hmol33/OpenWebRx-Installer?style=flat-square&color=blue)](https://github.com/hmol33/OpenWebRx-Installer/stargazers)
[![License](https://img.shields.io/github/license/hmol33/OpenWebRx-Installer?style=flat-square)](LICENSE)

Creating a Web SDR with OpenWebRX and a 7-20$ SDR Dongle.

## Vereisten

- Debian, Ubuntu of Fedora/RHEL
- sudo rechten
- Internetverbinding

## Installatie

```bash
bash <(curl -Ls https://raw.githubusercontent.com/hmol33/OpenWebRx-Installer/master/OpenWebRx-Installer.sh)
```

## Wat het script doet

1. Installeert build dependencies (build-essential, git, cmake, libfftw3-dev, libusb-1.0-0-dev, nmap)
2. Clone en compileert rtl-sdr
3. Schakelt de DVB-T driver uit (voorkomt conflicten met RTL-SDR)
4. Clone en compileert libcsdr
5. Clone OpenWebRX
6. Opent de configuratie-editor
7. Start OpenWebRX

## Gebruik

Na installatie: open http://localhost:8073 in je browser

## Bijdragers

- [hmol33](https://github.com/hmol33) — Onderhouder

## Licentie

MIT — zie [LICENSE](LICENSE) voor details.
