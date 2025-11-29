# Git version control
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "justdimaa";
        email = "justdimaa@duck.com";
      };
      init = {
        defaultBranch = "main";
      };
    };
    lfs.enable = true;
  };
}
