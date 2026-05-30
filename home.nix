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
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "sudo nixos-rebuild switch --flake ~/nix-dotfiles/";
      install_shell = "~/nix-dotfiles/scripts/install_shell.sh";
      run-shell = "~/nix-dotfiles/scripts/run_shell.sh";
    };
  };
  programs.zen-browser.enable = true;
  home.packages = [
    inputs.gazelle.packages.${pkgs.system}.default
  ];
  programs.librewolf = {
    enable = true;
    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      "privacy.clearOnShutdown.history" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };
}
