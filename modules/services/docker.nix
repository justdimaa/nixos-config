# Docker configuration
{ config, pkgs, ... }:

{
  # Enable Docker in rootless mode
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    
    # Auto-prune
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Install Docker Compose
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Add user to docker group (defined in core/users.nix)
  users.users.user.extraGroups = [ "docker" ];
}
