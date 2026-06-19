{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    pkgs.sqlite
  ];
  android = {
    enable = true;
    flutter.enable = true;
    platforms.version = [
      "32"
      "34"
      "35"
      "36"
    ];
  };
  enterShell = ''
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
    export LD_LIBRARY_PATH=${pkgs.sqlite.out}/lib:$LD_LIBRARY_PATH
    source <(flutter bash-completion)
  '';
}
