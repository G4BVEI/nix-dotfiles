{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  programs.steam.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    gamescope
  ];
}
