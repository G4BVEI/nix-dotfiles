{ pkgs, ... }:
{
  programs.niri.enable = true;
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Session manager
  services.sysc-greet = {
    enable = true;
    compositor = "niri"; # or "hyprland" or "sway"
  };
  environment.systemPackages = with pkgs; [
    #de-interface
    fuzzel
    quickshell
    #apps
    nautilus
    mission-center
    kitty
    #functionality
    wl-clipboard
    cliphist
    brightnessctl
    xwayland-satellite
    #cosmetic
    swaybg
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    barlow
  ];
}
