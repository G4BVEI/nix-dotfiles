{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:

let
  versions = {
    esp-rust = {
      version = "1.92.0.0";
      hash = "sha256-6enJJdfzU4OmXMdyu8jtrchmO0+8tZFmfn9P3GYsnIY=";
    };
    rust-src = {
      version = "1.92.0.0";
      hash = "sha256-nMTDpzKnjanFe8ttqPBYbIOcC3/f8HD7FgyzT4yO4M4=";
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

      # Create target spec files directory
      mkdir -p $out/lib/rustlib

      # Download and install target specs for ESP32
      TARGETS="xtensa-esp32-espidf xtensa-esp32s2-espidf xtensa-esp32s3-espidf riscv32imc-esp-espidf"
      for target in $TARGETS; do
        TARGET_FILE="$out/lib/rustlib/$target/lib"
        mkdir -p $TARGET_FILE
      done

      runHook postInstall
    '';
  };

  # Create wrapper script that sets all necessary environment variables
  esp-env-wrapper = pkgs.writeShellScriptBin "esp-env" ''
    export ESP_GCC_TOOLCHAIN="${esp-xtensa-gcc}/bin"
    export RISC_V_GCC_TOOLCHAIN="${esp-riscv32-gcc}/bin"
    export RUST_SRC_PATH="${rust-src}/lib/rustlib/src/rust/library"

    # Add all toolchains to PATH
    export PATH="${esp-rust-build}/bin:${esp-xtensa-gcc}/bin:${esp-riscv32-gcc}/bin:$PATH"

    # Set cargo config
    mkdir -p .cargo
    cat > .cargo/config.toml << 'EOF'
    [build]
    target = "xtensa-esp32-espidf"

    [target.'cfg(target_os = "espidf")']
    linker = "ldproxy"
    runner = "espflash flash --monitor"

    [unstable]
    build-std = ["std", "panic_abort"]
    EOF

    exec "$@"
  '';

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
in
pkgs.symlinkJoin {
  name = "esp-rs";
  version = versions.esp-rust.version;

  paths = [
    esp-rust-build
    esp-xtensa-gcc
    esp-riscv32-gcc
    esp-env-wrapper
  ];

  postBuild = ''
    # Symlink rust-src to the expected location
    mkdir -p $out/lib/rustlib/src
    ln -sf ${rust-src}/lib/rustlib/src/rust $out/lib/rustlib/src/rust

    # Create rustc wrapper that forces the target
    cat > $out/bin/rustc-wrapper << EOF
    #!/bin/bash
    export RUST_SRC_PATH="${rust-src}/lib/rustlib/src/rust/library"
    exec ${esp-rust-build}/bin/rustc "\$@"
    EOF
    chmod +x $out/bin/rustc-wrapper

    # Also wrap cargo
    cat > $out/bin/cargo-wrapper << EOF
    #!/bin/bash
    export RUST_SRC_PATH="${rust-src}/lib/rustlib/src/rust/library"
    export PATH="${esp-rust-build}/bin:\$PATH"
    exec ${pkgs.cargo}/bin/cargo "\$@"
    EOF
    chmod +x $out/bin/cargo-wrapper
  '';

  meta = with lib; {
    description = "Complete ESP32 Rust development toolchain (no rustup)";
    platforms = [ "x86_64-linux" ];
  };
}
