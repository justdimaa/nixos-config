# FUSE configuration for rootless mounting
{ config, pkgs, ... }:

{
  # Enable FUSE and allow non-root users to mount
  programs.fuse = {
    enable = true;
    userAllowOther = true;
  };
}
