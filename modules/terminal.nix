{ pkgs, ... }:
{
  #terminal funcionality packages, some also make part of the developer experience
  environment.systemPackages = with pkgs; [
    git
    gh
    nh
    yazi
    fastfetch
    mapscii
  ];
}
