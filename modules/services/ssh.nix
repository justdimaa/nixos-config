# SSH configuration
{ config, pkgs, ... }:

{
  # Enable OpenSSH daemon
  services.openssh = {
    enable = true;
    
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Open SSH port
  networking.firewall.allowedTCPPorts = [ 22 ];
}
