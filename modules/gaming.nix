{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    gamescope
    lutris
  ];
  #xwayland-satellite also makes part of this pack but it is more related to niri itself so it is in de.nix
}
