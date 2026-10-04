# OpenWebRx-Installer

<img src="https://img.shields.io/github/stars/hmol33/OpenWebRx-Installer?style=flat-square&color=blue" alt="Stars">
<img src="https://img.shields.io/github/forks/hmol33/OpenWebRx-Installer?style=flat-square&color=green" alt="Forks">
<img src="https://img.shields.io/github/license/hmol33/OpenWebRx-Installer?style=flat-square" alt="License">
<img src="https://github.com/hmol33/OpenWebRx-Installer/workflows/CI/badge.svg" alt="CI">

Creating a Web SDR with OpenWebRX and a 7-20$ SDR Dongle.

## Installatie

```bash
bash <(curl -Ls https://raw.githubusercontent.com/hmol33/OpenWebRx-Installer/master/OpenWebRx-Installer.sh)
```

## Gebruik

```bash
# Voer het installatiescript uit
bash <(curl -Ls https://raw.githubusercontent.com/hmol33/OpenWebRx-Installer/master/OpenWebRx-Installer.sh)

# Volg de instructies op het scherm
# Na installatie: open http://localhost:8073 in je browser
```

## Opties

| Variabele | Default | Beschrijving |
|-----------|---------|--------------|
| `DRY_RUN` | (leeg) | Zet op `1` voor dry-run mode (geen wijzigingen) |
| `LOG_FILE` | `/tmp/openwebrx-installer.log` | Pad naar log bestand |
| `INSTALL_DIR` | `$HOME/openwebrx-install` | Installatie directory |

### Voorbeelden

```bash
# Dry-run (test zonder wijzigingen)
DRY_RUN=1 bash <(curl -Ls https://raw.githubusercontent.com/hmol33/OpenWebRx-Installer/master/OpenWebRx-Installer.sh)

# Custom installatie directory
INSTALL_DIR=/opt/openwebrx bash <(curl -Ls https://raw.githubusercontent.com/hmol33/OpenWebRx-Installer/master/OpenWebRx-Installer.sh)
```

## Features

- Automatische dependency check
- Error handling met cleanup trap
- DRY_RUN mode voor veilig testen
- Structured logging
- GitHub Actions CI (shellcheck)

## Bijdragers

- [hmol33](https://github.com/hmol33) — Onderhouder

## Licentie

MIT — zie [LICENSE](LICENSE) voor details.
