# PipeWire audio configuration
{ config, pkgs, ... }:

{
  # Disable PulseAudio
  services.pulseaudio.enable = false;
  
  # Enable sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;

    # WirePlumber with Bluetooth profile enhancements
    wireplumber = {
      enable = true;
      # Disables hands-free profile to improve audio quality on headsets
      extraConfig."51-mitigate-annoying-profile-switch" = {
        "monitor.bluez.properties" = {
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" ];
          "bluez5.codecs" = ["sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd"];
        };
      };
    };
  };

  # Audio packages
  environment.systemPackages = with pkgs; [
    pavucontrol # PulseAudio Volume Control GUI
    helvum      # PipeWire patchbay
    easyeffects # Audio effects for PipeWire
  ];
}
