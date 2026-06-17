{
  description = "Dioxus development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Recommended: Add rust-overlay for easier Rust toolchain management
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
      # Define the Rust toolchain with the WASM target
      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ]; # rust-src is needed for some analysis
        targets = [ "wasm32-unknown-unknown" ];
      };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # 1. Rust toolchain with WASM target
          rustToolchain

          # 2. Dioxus CLI - Install from source, or use the prebuilt binary
          #    Using 'cargo install' is the most reliable way in Nix.
          #    This will compile the CLI from source (takes a few minutes).
          #    Alternatively, you can download the prebuilt binary manually.
          (pkgs.writeShellScriptBin "dx" ''
            # Check if dx is already installed globally; if not, use cargo install
            if ! command -v dx &> /dev/null; then
              echo "🔧 Installing dioxus-cli via cargo (this may take a few minutes)..."
              cargo install dioxus-cli
            fi
            exec dx "$@"
          '')

          # 3. System dependencies for Linux (from the Dioxus guide)
          #    These are required for the desktop (webview) renderer.
          libwebkit2gtk-4
          gtk4 # gtk4 is often required alongside webkit
          xdotool
          openssl
          pkg-config
          file
          librsvg
          libappindicator-gtk3
          lld # A modern linker, recommended for WASM and general Rust

          # 4. Build essentials and other common tools
          gcc
          cargo
          rustfmt
          clippy
        ];

        # Environment variables to help pkg-config and linker find libraries
        shellHook = ''
          echo "🚀 Dioxus development environment activated!"
          echo "📦 Rust target 'wasm32-unknown-unknown' is available."
          echo "🖥️  Desktop dependencies (WebKitGtk, etc.) are installed."
          echo ""
          echo "To start a new Dioxus project, run:"
          echo "  dx new my-app"
          echo "  cd my-app"
          echo "  dx serve"
        '';
      };
    };
}
