<p align="center">
  <img src="https://raw.githubusercontent.com/selene57/nixfiles/master/images/preview.png" alt="preview"/>
</p>

### Welcome!

This is my latest personal configuration for my unix system.

Here are some of the highlights of my configuration:

- **Operating System**             • [NixOs w/ Flakes](https://nixos.org/) and with [Home Manager](https://github.com/nix-community/home-manager)
- **Window Manager**               • [Xmonad](https://xmonad.org/)
- **Compositor**                   • [Picom](https://github.com/yshui/picom)
- **Shell**                        • [Zsh](https://www.zsh.org)
- **Terminal**                     • [Alacritty](https://github.com/alacritty/alacritty)
- **Bar**                          • [Taffybar](https://github.com/taffybar/taffybar)
- **Notify Daemon**                • [Dunst](https://github.com/dunst-project/dunst)
- **Application Launcher**         • [Rofi](https://github.com/davatorium/rofi)
- **File Manager**                 • [Thunar](https://github.com/xfce-mirror/thunar)

## Contents

 - [Installation](#installation)
    - [NixOs Based Installation](#nixos-based-installation)
 - [Change logs](#change-logs)
 - [Known Issues](#known-issues)
 - [Acknowledgments](#acknowledgments)
 - [License](#license)

## Installation

This installation guide hopes to be informative and clear about how to set up my personal configuration, as well as, any constituent parts, where possible.

### NixOs Based Installation

1. Make sure nix flakes is enabled on your system.
2. Clone repo to your home directory. (optionally fork it to your own repo then clone)
3. cd into nixfiles directory
4. Execute "sudo nixos-rebuild switch --flake .#"
5. Reboot and select the new generation.

### NixOs Updating

Updating in the future is as simple as using "system-build" zsh alias in the nixfiles directory. You'll probably want to fork and then clone the repo in step 2, so you can change the configuration for your needs. E.g. you'll want to change your user, hostname, etc.

### Other Distros

While the system config itself, can't be used. Many of the modules and packages can be managed with the nix package manager on other linux distros. And the /config/ folder holds many dotfiles that can be used regardless of package manager.

## Change logs

This section will be populated upon each version release.

[Version 1.1 - Release Notes](Release Notes/1-1.md)

Version 1.0 - Release Notes not provided as this was the base version for my system configuration.

## Known Issues

- The custom papirus icon theme needs to be installed.
- The .nix system and user files needs to be better partitioned into individual responsibilities. (ongoing effort)
- Neovim needs to further be configured. (ongoing effort: telescope, nvim-cmp, and lspconfig need to be setup still)
- The zsh clipboard plugin throws an error on zsh shell launch due to no system clipboard being setup.

## Acknowledgments

The following were either major inspirations or direct resources in producing my current configuration. This is not an exhaustive list.

- [owl4ce](https://github.com/owl4ce/dotfiles)
- [Icy-thought](https://github.com/Icy-Thought/Snowflake)
- [Ivan Malison](https://github.com/IvanMalison/dotfiles)

## License

All files in this repository constitute a project, which is free and open source project distributed under the terms of the GNU General Public License, version 3. See the [`LICENSE`](LICENSE) file for details.

When the files are attributed to other sources than this repository, they belong under their sources'respective licenses.