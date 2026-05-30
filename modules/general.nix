{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.nixpkgs-old.legacyPackages.${pkgs.system}.obsidian
    pkgs.logseq
  ];
}
