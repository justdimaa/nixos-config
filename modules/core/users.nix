# User configuration
{ config, pkgs, ... }:

{
  # Define user account
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ 
      "networkmanager" 
      "wheel"        # sudo access
      "video"        # video devices
      "audio"        # audio devices
      "dialout"      # serial devices
    ];
    shell = pkgs.fish;
  };

  # Fish shell
  programs.fish.enable = true;
}
