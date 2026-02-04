{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    temurin-jre-bin-21
  ];
}
