# Virtualization with virt-manager and QEMU
{ config, pkgs, lib, ... }:

{
  # Enable libvirt and QEMU
  virtualisation = {
    libvirtd = {
      enable = true;
      # qemu = {
      #   package = pkgs.qemu_kvm;
      #   runAsRoot = true;
      #   swtpm.enable = true;
      # };
    };
    spiceUSBRedirection.enable = true;
  };

  # Virt-manager
  programs.virt-manager.enable = true;

  # Add user to libvirtd group (defined in core/users.nix)
  users.users.user.extraGroups = [ "libvirtd" ];

  # Enable dnsmasq for virtual networks
  # virtualisation.libvirtd.allowedBridges = [
  #   "nm-bridge"
  #   "virbr0"
  # ];

  networking = {
    useDHCP = lib.mkForce false;
    interfaces = {
      enp5s0.useDHCP = true;
      br0.useDHCP = true;
    };
    bridges = {
      "br0" = {
        interfaces = [ "enp5s0" ];
      };
    };
  };
}
