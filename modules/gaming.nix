{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  hardware.bluetooth.enable = true;
  # Required for PS3/PS4 controllers over Bluetooth
  hardware.bluetooth.package = pkgs.bluez;
  # Recommended for controller support in Steam
  hardware.steam-hardware.enable = true;
  environment.systemPackages = with pkgs; [
    #minecraft stuff
    temurin-jre-bin-21
    #gta and so on
    gamescope
    #epic games stuff
    (heroic.override {
      extraPkgs = pkgs: [
        pkgs.gamescope
      ];
    })
    #hydralauncher
  ];
  #xwayland-satellite also makes part of this pack but it is more related to niri itself so it is in de.nix
}
