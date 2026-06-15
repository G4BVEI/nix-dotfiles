{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:
let
  versions = {
    esp-rust = {
      version = "1.92.0.0"; # or "1.91.0.0" for smoltcp support
      hash = "sha256-6enJJdfzU4OmXMdyu8jtrchmO0+8tZFmfn9P3GYsnIY="; # Will need to update
    };
    rust-src = {
      version = "1.92.0.0"; # Must match esp-rust version
      hash = "sha256-nMTDpzKnjanFe8ttqPBYbIOcC3/f8HD7FgyzT4yO4M4="; # Will need to update
    };
    gcc = {
      version = "14.2.0_20241119";
      xtensa-hash = "sha256-pX2KCnUoGZtgqFmZEuNRJxDMQgqYYPRpswL3f3T0nWE=";
      riscv32-hash = "sha256-67O34FYUnVG2nfkfQj2yH874qDSYx4F/16xxPi0kNbY=";
    };
    defaultArch = "x86_64-unknown-linux-gnu";
    gccArch = "x86_64-linux-gnu";
  };

  mkGccToolchain =
    {
      name,
      arch,
      hash,
    }:
    pkgs.stdenv.mkDerivation {
      pname = "esp-${name}-gcc";
      version = versions.gcc.version;

      src = pkgs.fetchzip {
        url = "https://github.com/espressif/crosstool-NG/releases/download/esp-${versions.gcc.version}/${arch}-esp-elf-${versions.gcc.version}-${versions.gccArch}.tar.xz";
        inherit hash;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -r ./* $out/
        runHook postInstall
      '';

      meta = with lib; {
        description = "ESP32 ${name} GCC toolchain";
        homepage = "https://github.com/espressif/crosstool-NG";
        license = licenses.gpl2Plus;
        platforms = [ "x86_64-linux" ];
      };
    };

  esp-rust-build = pkgs.stdenv.mkDerivation {
    pname = "esp-rust-build";
    version = versions.esp-rust.version;

    src = pkgs.fetchzip {
      url = "https://github.com/esp-rs/rust-build/releases/download/v${versions.esp-rust.version}/rust-${versions.esp-rust.version}-${versions.defaultArch}.tar.xz";
      hash = versions.esp-rust.hash;
    };

    nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
    buildInputs = with pkgs; [
      stdenv.cc.cc
      zlib
    ];

    patchPhase = ''
      patchShebangs ./install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      ./install.sh --destdir=$out --prefix="" --disable-ldconfig --without=rust-docs-json-preview,rust-docs
      runHook postInstall
    '';

    meta = with lib; {
      description = "ESP32 Rust toolchain";
      homepage = "https://github.com/esp-rs/rust-build";
      license = with licenses; [
        mit
        asl20
      ];
      platforms = [ "x86_64-linux" ];
    };
  };

  esp-xtensa-gcc = mkGccToolchain {
    name = "xtensa";
    arch = "xtensa";
    hash = versions.gcc.xtensa-hash;
  };

  esp-riscv32-gcc = mkGccToolchain {
    name = "riscv32";
    arch = "riscv32";
    hash = versions.gcc.riscv32-hash;
  };

  rust-src = pkgs.fetchzip {
    url = "https://github.com/esp-rs/rust-build/releases/download/v${versions.rust-src.version}/rust-src-${versions.rust-src.version}.tar.xz";
    hash = versions.rust-src.hash;
  };

  esp-rs-base = pkgs.symlinkJoin {
    name = "esp-rs-base-${versions.esp-rust.version}";
    paths = [
      esp-rust-build
      esp-xtensa-gcc
      esp-riscv32-gcc
    ];
    meta = {
      description = "Base ESP32 toolchain components";
      platforms = [ "x86_64-linux" ];
    };
  };
in
pkgs.stdenv.mkDerivation {
  pname = "esp-rs";
  version = versions.esp-rust.version;

  src = rust-src;

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  autoPatchelfIgnoreMissingDeps = [ "*" ];

  patchPhase = ''
    patchShebangs ./install.sh
  '';

  installPhase = ''
    runHook preInstall

    # Start with the base toolchain
    mkdir -p $out
    cp -rL ${esp-rs-base}/* $out/
    chmod -R u+w $out

    # Install rust-src on top
    ./install.sh --destdir=$out --prefix="" --disable-ldconfig

    runHook postInstall
  '';

  passthru = {
    inherit esp-rust-build esp-xtensa-gcc esp-riscv32-gcc;
    version = versions.esp-rust.version;
  };

  meta = with lib; {
    description = "Complete ESP32 Rust development toolchain";
    longDescription = ''
      A complete toolchain for developing Rust applications on ESP32 microcontrollers.
      Includes Rust compiler with ESP32 targets, Xtensa and RISC-V GCC toolchains,
      and all necessary components for no_std ESP-HAL development.
    '';
    homepage = "https://github.com/esp-rs";
    license = with licenses; [
      mit
      asl20
      gpl2Plus
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
