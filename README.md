# OpenWebRx-Installer

Automated installer for OpenWebRx — a web-based SDR receiver using affordable RTL-SDR dongles.

## Features

- Supports RTL-SDR v3 dongles (7-20$)
- Web-based interface for listening to radio frequencies
- Multi-user support with individual configurations
- Waterfall display and audio streaming
- Compatible with Debian/Ubuntu/Raspberry Pi

## Requirements

- RTL-SDR dongle (RTL2832U-based)
- Debian/Ubuntu or Raspberry Pi OS
- Minimum 512MB RAM

## Installation

```bash
git clone https://github.com/hmol33/OpenWebRx-Installer.git
cd OpenWebRx-Installer
chmod +x install.sh
sudo ./install.sh
```

## Usage

Access the web interface at `http://localhost:8073` after installation.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

See [LICENSE](LICENSE) for details.
