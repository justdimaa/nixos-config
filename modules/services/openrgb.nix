# OpenRGB service configuration
{ pkgs, ... }:

{
  # Enable OpenRGB for RGB lighting control
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "intel"; 
    server.port = 6742;
  };

  # Tried it to fix device access issues with my Hypercast X microphone
  # but it didn't help.
  # environment.systemPackages = with pkgs; [
  #   libusb1
  #   hidapi
  # ];
}
