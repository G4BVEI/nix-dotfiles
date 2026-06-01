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

        # We add :CDCOnBoot=default to fix the serial output on /dev/ttyACM0
        fqbn = "esp32:esp32:esp32";
        port = "/dev/ttyACM0";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            arduino-cli
            python3
            python3Packages.pyserial
            esptool
            clang-tools
            arduino-language-server
          ];

          shellHook = ''
            echo "--- ESP32 Arduino Aliases Loaded ---"
            echo "Device: ${port} | FQBN: ${fqbn}"

            # Aliases for a faster workflow
            alias esp-build='arduino-cli compile --fqbn ${fqbn} .'
            alias esp-up='arduino-cli upload -p ${port} --fqbn ${fqbn} .'
            alias esp-go='esp-build && esp-up'

            # Monitor with the correct baudrate and reset pins disabled
            alias esp-mon='arduino-cli monitor -p ${port} --config baudrate=9600 --config dtr=off --config rts=off'

            # Initialize arduino-cli if needed
            if [ ! -d ~/.arduino15/packages/esp32 ]; then
              echo "Installing ESP32 core, this might take a minute..."
              arduino-cli config init --overwrite
              arduino-cli core update-index
              arduino-cli core install esp32:esp32
            fi
          '';
        };
      }
    );
}
