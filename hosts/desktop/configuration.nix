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
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
    # ../../modules/hardware/printing.nix
    
    # Desktop
    ../../modules/desktop/kde.nix
    
    # Services
    ../../modules/services/flatpak.nix
    # ../../modules/services/ssh.nix
    ../../modules/services/docker.nix
    ../../modules/services/virtmanager.nix
    ../../modules/services/ledfx.nix
    ../../modules/services/openrgb.nix
    
    # Programs
    # Core tools
    ../../modules/programs/git.nix
    ../../modules/programs/direnv.nix
    
    # Development
    ../../modules/programs/vscode.nix
    ../../modules/programs/android.nix
    
    # Media creation
    ../../modules/programs/obs.nix
  ];

  # Hostname
  networking.hostName = "nixos-desktop";

  # LUKS disk encryption - HOST SPECIFIC
  boot.initrd.luks.devices = {
    "luks-875f1ee6-1b88-4846-a97b-08569d8596a6" = {
      device = "/dev/disk/by-uuid/875f1ee6-1b88-4846-a97b-08569d8596a6";
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

  # Custom allowed ports for BambuLab and Vite
  networking.firewall = {
    allowedTCPPorts = [ 990 123 6000 322 8883 6742 5173 ];
    allowedUDPPorts = [ 123 1990 2021 ];
  };
  
  system.stateVersion = "24.05"; # Don't change this
}
