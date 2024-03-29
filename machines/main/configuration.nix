# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  #boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_6_2;
  hardware.enableRedistributableFirmware = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Add non latin symbols
  fonts = {
    fonts = with pkgs; [noto-fonts noto-fonts-cjk noto-fonts-extra];
    enableDefaultFonts = true;
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif CJK JP" ];
      sansSerif = [ "Noto Sans CJK JP" ];
      monospace = [ "Noto Sans Mono CJK JP" ];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dimaa = {
    isNormalUser = true;
    description = "dimaa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "dimaa";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.qemuGuest.enable = true;

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.open = true;

  networking.extraHosts = builtins.readFile ../../secrets/extra-hosts;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable docker
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      #defaultNetwork.dnsname.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sweet
    jetbrains.idea-ultimate
    direnv
    nix-direnv
    git
    podman-compose
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        matklad.rust-analyzer
        tamasfe.even-better-toml
        mkhl.direnv
        ms-toolsai.jupyter
        zxh404.vscode-proto3
        redhat.java
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscodeintellicode";
          publisher = "VisualStudioExptTeam";
          version = "1.2.29";
          sha256 = "Wl++d7mCOjgL7vmVVAKPQQgWRSFlqL4ry7v0wob1OyU=";
        }
        {
          name = "vscord";
          publisher = "leonardssh";
          version = "5.0.18";
          sha256 = "F/WB6RPmKvQDEehdlGMmBulpcsfXiOxuWGtXYiPVKvs=";
        }
        {
          name = "vscode-java-pack";
          publisher = "vscjava";
          version = "0.25.11";
          sha256 = "NhbGaEXMIx6ZX2eCN1ZCIzbGVuhHZU/XDgdc34P+iNU=";
        }
        {
          name = "vscode-maven";
          publisher = "vscjava";
          version = "0.41.0";
          sha256 = "4XJX56IjZKq/nxpGwtxXrncr6YS/gbdgE7S716I8j8A=";
        }
        {
          name = "vscode-gradle";
          publisher = "vscjava";
          version = "3.12.7";
          sha256 = "dE9Hxs7cGhZkNK8BVpHGiY+/CDw2pCeVVVqwYid+GHU=";
        }
        {
          name = "vscode-java-debug";
          publisher = "vscjava";
          version = "0.50.0";
          sha256 = "5aq7k/juSYgQd67mOJiz3dod/8fZgiJ7G8r7uGmJ2s4=";
        }
        {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.38.2";
          sha256 = "XhqcnJBP91x26JUWzjGi095IqboesMrb4KDRYLx1er0=";
        }
      ];
    })
  ];

  environment.gnome.excludePackages = (with pkgs; [
    #gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    #gnome-music
    #gnome-terminal
    #gedit # text editor
    epiphany # web browser
    geary # email reader
    #evince # document viewer
    #gnome-characters
    #totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # if you also want support for flakes
  # nixpkgs.overlays = [
  #   (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
