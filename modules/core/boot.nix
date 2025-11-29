# Boot configuration
{ config, pkgs, lib, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false; # Disabled when using lanzaboote
  boot.loader.efi.canTouchEfiVariables = true;

  # Boot settings
  boot.tmp.cleanOnBoot = true;
  
  # Kernel parameters (optional)
  # boot.kernelParams = [ "quiet" "splash" ];

  # Secure Boot for NixOS
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Note: Before this works, you need to:
  # 1. Generate Secure Boot keys:
  #    sudo sbctl create-keys
  # 2. Enroll keys (with system in Setup Mode):
  #    sudo sbctl enroll-keys --microsoft
  # 3. After rebuilding, sign the bootloader:
  #    This happens automatically with lanzaboote
  
  environment.systemPackages = with pkgs; [
    sbctl # Secure Boot key management
  ];
}
