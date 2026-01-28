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
    fuzzel
    nemo
    wl-clipboard
    cliphist
    brightnessctl
    swaybg
    xwayland-satellite
    quickshell
  ];
}
