# KDE Plasma Desktop Environment
{ config, pkgs, ... }:

{
  # Enable KDE Plasma with Wayland
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "user";
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;

  # Enable XWayland for X11 app compatibility
  programs.xwayland.enable = true;

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Fonts for international characters and emojis
  fonts.packages = with pkgs; [
    # Noto fonts for comprehensive language support
    noto-fonts
    noto-fonts-cjk-sans # Chinese, Japanese, Korean
    noto-fonts-cjk-serif
    noto-fonts-color-emoji # Emoji support
    
    # Icon fonts
    # nerdfonts # Programming ligatures and icons
  ];

  # Enable Partition Manager
  programs.partition-manager.enable = true;

  # Enable KDE Connect (optional)
  programs.kdeconnect.enable = false;
}
