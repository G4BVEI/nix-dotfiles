{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    gh
    nh
    yazi
    fastfetch
    mapscii
  ];

}