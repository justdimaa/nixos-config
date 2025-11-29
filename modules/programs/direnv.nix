# CLI tools and utilities
{ pkgs, ... }:

{
  # Enable direnv for automatic environment loading
  programs.direnv.enable = true;
  
  # Keep build outputs and derivations for debugging
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
}
