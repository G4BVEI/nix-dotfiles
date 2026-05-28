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
  enterShell = ''
    export CHROME_EXECUTABLE=${pkgs.chromium}/bin/chromium
    source <(flutter bash-completion)
  '';
}
