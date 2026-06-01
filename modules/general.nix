{ pkgs, inputs, ... }:
let
  oldPkgs = import inputs.nixpkgs-old {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = [
    oldPkgs.obsidian
    pkgs.logseq
  ];
}
