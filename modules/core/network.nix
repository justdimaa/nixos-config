# Network configuration
{ config, pkgs, ... }:

{
  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall.enable = true;

  # DNS
  # networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
}
