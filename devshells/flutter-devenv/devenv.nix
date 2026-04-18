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
  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk17;
  };
  packages = [
    pkgs.chromium
  ];
  enterShell = ''
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
  '';
}
