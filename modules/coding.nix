{ pkgs, ... }:
{
  #whilst this includes most of the dev experience, some functionality still is at terminal.nix
  environment.systemPackages = with pkgs; [
    #ide
    zed-editor
    #lsp
    nixd
    nil
    qt6.qtdeclarative
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true; # important for nix shells
}
