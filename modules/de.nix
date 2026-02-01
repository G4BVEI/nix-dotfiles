{ pkgs, inputs, ... }:
{
  programs.niri.enable = true;
  # Session manager
  services.sysc-greet = {
    enable = true;
    compositor = "niri"; # or "hyprland" or "sway"
  };
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  environment.systemPackages = [
  ];
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [
    quickshell
    #apps
    nautilus
    mission-center
    kitty
    #functionality
    wl-clipboard
    cliphist
    brightnessctl
    #compatibility layer
    xwayland-satellite
    #interface stuff
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    #interface fallback
    fuzzel
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    barlow
  ];
}
