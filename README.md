# OpenWebRx-Installer

<img src="https://img.shields.io/github/stars/hmol33/OpenWebRx-Installer?style=flat-square&color=blue" alt="Stars">
<img src="https://img.shields.io/github/forks/hmol33/OpenWebRx-Installer?style=flat-square&color=green" alt="Forks">
<img src="https://img.shields.io/github/license/hmol33/OpenWebRx-Installer?style=flat-square" alt="License">
<img src="https://github.com/hmol33/OpenWebRx-Installer/actions/workflows/ci.yml/badge.svg?style=flat-square" alt="CI">
<img src="https://github.com/hmol33/OpenWebRx-Installer/actions/workflows/gource.yml/badge.svg?style=flat-square" alt="Gource">

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

## Bijdragers

- [hmol33](https://github.com/hmol33) — Onderhouder


## 🎥 Gource Visualization

De ontwikkelhistorie van dit project in een film:

<video src="https://raw.githubusercontent.com/hmol33/hmol33-OpenWebRx-Installer/master/gource.mp4" controls width="100%"></video>

*De video wordt automatisch gegenereerd door de [Gource workflow](.github/workflows/gource.yml) bij elke push.*

Lokale video genereren:
```bash
gource --max-files 1000 --key -800x600 \
  --highlight-users --filename-time 3 --output-framerate 25 \
  -s 0.6 --multi-sampling --auto-skip-seconds 0.1 \
  --stop-at-end --hide mouse,progress -o gource.ppm

ffmpeg -y -r 15 -f image2pipe -vcodec ppm -i gource.ppm \
  -vcodec libx264 -preset medium -pix_fmt yuv420p \
  -crf 1 -threads 0 -bf 0 gource.mp4
```

## Licentie

MIT — zie [LICENSE](LICENSE) voor details.
