{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  programs.steam.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    drivers = [ "amdgpu" ];
  };
  environment.systemPackages = with pkgs; [
    gamescope
  ];
}
