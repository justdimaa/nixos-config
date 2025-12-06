# Main configuration for desktop
{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # Core system
    ../../modules/core/nix.nix
    ../../modules/core/boot.nix
    ../../modules/core/network.nix
    ../../modules/core/locale.nix
    ../../modules/core/users.nix

    # Hardware
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/fingerprint.nix

    # Desktop
    ../../modules/desktop/kde.nix

    # Services
    ../../modules/services/flatpak.nix
    # ../../modules/services/ssh.nix
    ../../modules/services/docker.nix

    # Programs
    # Core tools
    ../../modules/programs/git.nix
    ../../modules/programs/direnv.nix

    # Development
    ../../modules/programs/vscode.nix
    ../../modules/programs/android.nix
  ];

  # Hostname
  networking.hostName = "nixos-laptop";

  # Fix "Configuring interfaces" loop
  networking.networkmanager.wifi.backend = "iwd";

  # LUKS disk encryption - HOST SPECIFIC
  boot.initrd.luks.devices = {
    "luks-3b5e812e-61c6-4c91-a7ac-903a2de5dbbc" = {
      device = "/dev/disk/by-uuid/3b5e812e-61c6-4c91-a7ac-903a2de5dbbc";
      preLVM = true;
      allowDiscards = true; # Enable TRIM for SSDs
    };
  };

  # Support for encrypted volumes in initrd
  boot.initrd.availableKernelModules = [ "dm-crypt" "aes" ];

  # Host-specific configuration
  # Add any device-specific settings here
  environment.systemPackages = with pkgs; [
    usbutils
  ];

  system.stateVersion = "25.11"; # Don't change this
}
