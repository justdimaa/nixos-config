{ config, pkgs, ... }:

{
  # Enable the fingerprint daemon
  services.fprintd.enable = true;
  
  # (Optional) specific PAM configuration if needed later
  # security.pam.services.sddm.fprintAuth = true; 
}
