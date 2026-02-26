{ pkgs, ... }:
{
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    ani-cli
    obsidian
  ];
}
