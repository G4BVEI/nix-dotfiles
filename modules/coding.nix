{ pkgs, ... }:
{
  #whilst this includes most of the dev experience, some functionality still is at terminal.nix
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    nixd
    nil
    docker-compose
    zed-editor
    supabase-cli
    devenv
    bash-completion
  ];
  programs.bash = {
    enable = true;
    # Aliases globais
    shellAliases = {
      btw = "sudo nixos-rebuild switch --flake ~/nix-dotfiles/";
      install_shell = "~/nix-dotfiles/scripts/install_shell.sh";
      run-shell = "~/nix-dotfiles/scripts/run_shell.sh";
    };

    # Habilita autocomplete
    completion.enable = true;

    # Inicialização do Bash (global)
    shellInit = ''
      # Carapace
      if command -v carapace &> /dev/null; then
        source <(carapace _carapace)
      fi
    '';
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nixd
    nil
  ];
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true; # important for nix shells
}
