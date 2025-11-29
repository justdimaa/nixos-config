# Android development tools
{ config, pkgs, ... }:

# This section here is currently a mess.
# The Android SDK takes up a lot of space (100 GB+) to build and install.
# Just download it manually from the official site for now.
# You can uncomment the lines below to try installing via Nix,

{
  # Enable Android development
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    # Android SDK and tools
    # androidenv.androidPkgs.androidsdk
    jdk17
    
    # Android Studio (optional)
    # android-studio
  ];

  # Android SDK setup (if needed)
  # You may want to set ANDROID_HOME environment variable
  # environment.variables.ANDROID_HOME = "${pkgs.androidsdk}/libexec/android-sdk";

  # Accept Android SDK licenses automatically
  # nixpkgs.config.android_sdk.accept_license = true;

  # Add user to adbusers group (if needed)
  users.users.user.extraGroups = [ "adbusers" ];
}
