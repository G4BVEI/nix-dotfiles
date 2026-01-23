# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  #====================================================================
  #DEFAULTS, DONT MESS
  #====================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gabvei = {
    isNormalUser = true;
    description = "gabvei";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  # Configure console keymap
  console.keyMap = "br-abnt2";
  #setting up flakes and stuff
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
  # =====================================================================
  # System generals
  # =====================================================================
  # Niri wm
  programs.niri.enable = true;
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Session manager
  services.sysc-greet = {
    enable = true;
    compositor = "niri"; # or "hyprland" or "sway"
  };
  # ======================================================
  # General programs/pkgs
  # ======================================================
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    git
    kitty
    zed-editor
    fuzzel
    nemo
    wl-clipboard
    cliphist
    brightnessctl
    gh
    nh
    nixd
    nil
    ghostty
    yazi
    mission-center
    swaybg
  ];

  #Language server
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nixd
    nil
  ];
}
