{
  description = "A modern Nix flake for ESP32 Rust development with Xtensa and RISC-V targets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        pkgs = import nixpkgs { inherit system; };

        esp-rs = pkgs.callPackage ./esp-rs.nix { };

        # Common development dependencies
        commonBuildInputs = with pkgs; [
          pkg-config
          libudev-zero
          libusb1
        ];

        # Development tools
        devTools = with pkgs; [
          cargo
          espflash
          cargo-generate
          rust-analyzer
          esp-generate
          clang-analyzer
        ];
      in
      {
        packages = {
          inherit esp-rs;
          default = esp-rs;
        };

        devShells = {
          default = pkgs.mkShell {
            name = "esp-rs-dev";

            buildInputs = commonBuildInputs ++ devTools ++ [ esp-rs ];

            shellHook = ''
              export RUSTUP_TOOLCHAIN=${esp-rs}
            '';
          };

          # Minimal shell without extra tools
          minimal = pkgs.mkShell {
            name = "esp-rs-minimal";
            buildInputs = commonBuildInputs ++ [ esp-rs ];
            shellHook = ''
              export RUSTUP_TOOLCHAIN=${esp-rs}
            '';
          };

          # CI/build shell
          ci = pkgs.mkShell {
            name = "esp-rs-ci";
            buildInputs = commonBuildInputs ++ [
              esp-rs
              pkgs.cargo-espflash
            ];
            shellHook = ''
              export RUSTUP_TOOLCHAIN=${esp-rs}
              export CI=1
              export LD_LIBRARY_PATH="${
                pkgs.lib.makeLibraryPath [
                  pkgs.zlib
                  pkgs.stdenv.cc.cc
                ]
              }:$LD_LIBRARY_PATH"
            '';
          };
        };

        checks = {
          # Verify the toolchain builds
          toolchain-builds = esp-rs;
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
