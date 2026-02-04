# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    ./minecraft.nix
    ./modules/de.nix
    ./hardware-configuration.nix
    ./modules/gaming.nix
    ./modules/terminal.nix
    ./modules/coding.nix
    ./modules/general.nix
  ];
  #====================================================================
  #DEFAULTS, DONT MESS
  #====================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "asus_wmi" ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", KERNEL=="BAT0", \
      ATTR{charge_control_end_threshold}="85"
  '';
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
  console.keyMap = "us";
  #setting up flakes and stuff
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "25.11";
}
