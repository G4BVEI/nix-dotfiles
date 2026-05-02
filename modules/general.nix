{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    logseq
  ];
}
