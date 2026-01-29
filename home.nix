{
  config,
  inputs,
  pkgs,
  ...
}:

{
  home.username = "gabvei";
  home.homeDirectory = "/home/gabvei";
  home.stateVersion = "25.05";
  xdg.configFile = {
    "niri/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/gabvei/nix-dotfiles/config/niri/config.kdl";
    };
    "fuzzel/fuzzel.ini" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/gabvei/nix-dotfiles/config/fuzzel/fuzzel.ini";
    };
    "kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/gabvei/nix-dotfiles/config/kitty/kitty.conf";
    };
    "quickshell/shell.qml" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/gabvei/nix-dotfiles/config/quickshell/shell.qml";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "sudo nixos-rebuild switch --flake ~/nix-dotfiles/";
    };
  };
  home.packages = [
    inputs.gazelle.packages.${pkgs.system}.default
  ];
}
