# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_6_1;
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

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # hardware.nvidia.modesetting.enable = true;
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
      defaultNetwork.dnsname.enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sweet
    jetbrains.idea-ultimate
    direnv
    nix-direnv
    conky
    git
    podman-compose
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        matklad.rust-analyzer
        tamasfe.even-better-toml
        mkhl.direnv
        eamodio.gitlens
        ms-toolsai.jupyter
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscodeintellicode";
          publisher = "VisualStudioExptTeam";
          version = "1.2.30";
          sha256 = "Wl++d7mCOjgL7vmVVAKPQQgWRSFlqL4ry7v0wob1OyU=";
        }
        {
          name = "vscord";
          publisher = "leonardssh";
          version = "5.0.18";
          sha256 = "F/WB6RPmKvQDEehdlGMmBulpcsfXiOxuWGtXYiPVKvs=";
        }
        {
          name = "language-julia";
          publisher = "julialang";
          version = "1.38.2";
          sha256 = "B7jIdI+F39maX/I+rffIjmS59+B9atsr5rzX+c++Wqk=";
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

  networking.firewall = {
    allowedUDPPorts = [ 56134 ]; # Clients and peers can use the same port, see listenport
  };

  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.13.94.29/24" ];
      listenPort = 56134; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      privateKey = builtins.readFile ../../secrets/wg0-private-key;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = builtins.readFile ../../secrets/wg0-public-key;

          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/5" "8.0.0.0/7" "11.0.0.0/8" "12.0.0.0/6" "16.0.0.0/4" "32.0.0.0/3" "64.0.0.0/2" "128.0.0.0/2" "192.0.0.0/9" "192.128.0.0/11" "192.160.0.0/13" "192.169.0.0/16" "192.170.0.0/15" "192.172.0.0/14" "192.176.0.0/12" "192.192.0.0/10" "193.0.0.0/8" "194.0.0.0/7" "196.0.0.0/6" "200.0.0.0/6" "204.0.0.0/7" "206.0.0.0/9" "206.128.0.0/10" "206.192.0.0/12" "206.208.0.0/13" "206.216.0.0/16" "206.217.0.0/17" "206.217.128.0/18" "206.217.192.0/20" "206.217.208.0/21" "206.217.216.0/28" "206.217.216.16/30" "206.217.216.20/31" "206.217.216.22/32" "206.217.216.24/29" "206.217.216.32/27" "206.217.216.64/26" "206.217.216.128/25" "206.217.217.0/24" "206.217.218.0/23" "206.217.220.0/22" "206.217.224.0/19" "206.218.0.0/15" "206.220.0.0/14" "206.224.0.0/11" "207.0.0.0/8" "208.0.0.0/4" "224.0.0.0/3" ];

          # Set this to the server IP and port.
          endpoint = builtins.readFile ../../secrets/wg0-endpoint;

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
