# Flatpak configuration
{ config, pkgs, ... }:

{
  # Enable Flatpak
  services.flatpak.enable = true;

  # Note: After installation, you may want to add Flathub:
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
