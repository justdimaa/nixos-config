# OBS Studio for streaming and recording
{ config, pkgs, ... }:

{
  # Enable OBS Studio with Virtual Camera and DroidCam plugin
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };
}
