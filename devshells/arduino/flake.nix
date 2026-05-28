{
  description = "ESP32 Arduino Development Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            arduino-cli
            python3
            python3Packages.pyserial
            esptool
            # For Zed's language server
            clang-tools
          ];

          shellHook = ''
            echo "--- ESP32 Arduino Dev Environment ---"
            echo "Device: /dev/ttyACM0"

            # Initialize arduino-cli if needed
            if [ ! -f ~/.arduino15/arduino-cli.yaml ]; then
              arduino-cli config init
              arduino-cli core update-index
              arduino-cli core install esp32:esp32
            fi
          '';
        };
      }
    );
}
