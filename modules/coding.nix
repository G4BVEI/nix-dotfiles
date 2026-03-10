{ pkgs, ... }:
{
  #whilst this includes most of the dev experience, some functionality still is at terminal.nix
  environment.systemPackages = with pkgs; [
    nixd
    nil
    devenv
    cachix
    ciscoPacketTracer9
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nixd
    nil
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true; # important for nix shells
}
