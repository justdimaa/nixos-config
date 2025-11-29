# NVIDIA GPU configuration
{ config, pkgs, lib, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Load nvidia driver for Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Enable power management (experimental)
    # Useful for laptops to save battery
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the open source kernel module (for newer GPUs)
    # Set to false for proprietary driver
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version
    # Options: stable, beta, production (latest stable), or legacy versions
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Additional NVIDIA packages
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];
}
