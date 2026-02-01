{ pkgs, ... }:
{
  #terminal funcionality packages, some also make part of the developer experience
  environment.systemPackages = with pkgs; [
    git
    gh
    nh
    fastfetch
    mapscii
    starship
    environment.systemPackages = with pkgs; [
	(yazi.override {
		_7zz = _7zz-rar;  # Support for RAR extraction
	})
    ];
    # archives
    p7zip
    # search / navigation
    fd
    ripgrep
    fzf
    zoxide
    # misc
    jq
  ];
}
