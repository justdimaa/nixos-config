# Printing configuration
{ config, pkgs, ... }:

{
  # Enable CUPS for printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # Add printer drivers as needed
      gutenprint
      hplip
    ];
  };

  # Enable printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
