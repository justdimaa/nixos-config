# Nix configuration
{ config, pkgs, ... }:

{
  # Enable flakes and nix command
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    
    # Optimize store automatically
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
}
