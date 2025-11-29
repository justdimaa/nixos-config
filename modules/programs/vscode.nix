# Visual Studio Code
{ config, pkgs, ... }:

{
  # Install Visual Studio Code with FHS compatibility
  environment.systemPackages = with pkgs; [
    vscode-fhs
  ];
}
