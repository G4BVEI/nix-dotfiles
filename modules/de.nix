{ pkgs, inputs, ... }:
{
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  #window manager
  programs.niri.enable = true;
  # Session manager
  services.sysc-greet = {
    enable = true;
    compositor = "niri";
  };
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [
    #automount
    udiskie
    #interface stuff
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    #apps
    mission-center
    kitty
    #functionality
    wl-clipboard
    cliphist
    brightnessctl
    #interface fallback
    nautilus
    fuzzel
    imv
    mpv
    vlc
    ffmpeg
    pinta
    gpu-screen-recorder
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
