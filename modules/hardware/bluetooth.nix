# Bluetooth configuration
{ config, pkgs, ... }:

{
  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source";
        ControllerMode = "dual";
        FastConnectable = true;
      };
      Policy.AutoEnable = true;
    };
  };
}
