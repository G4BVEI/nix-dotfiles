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
  ];
  #xwayland also makes part of this pack but it is more related to the wm itself so it is in de.nix
}
