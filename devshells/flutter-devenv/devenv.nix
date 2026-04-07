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
  packages = [
    pkgs.chromium
  ];
  enterShell = ''
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
  '';
}
