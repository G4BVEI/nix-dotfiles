{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  android = {
    enable = true;
    flutter.enable = true;
  };
  environment.systemPackages = with pkgs; [
    chromium
  ];
  shellHook = ''
    export CHROME_BIN=${pkgs.chromium}/bin/chromium
  '';
}
