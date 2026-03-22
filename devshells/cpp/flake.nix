{
  description = "Full C/C++ development environment (clean + extensible)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Compilers
          gcc
          clang

          # Build systems
          gnumake
          cmake
          ninja

          # Debugging
          gdb

          # Tooling
          clang-tools # clangd, clang-tidy, etc.

          # Utilities
          pkg-config
        ];

        shellHook = ''
          echo "C/C++ dev environment ready 🚀"
          echo "gcc: $(gcc --version | head -n1)"
          echo "clang: $(clang --version | head -n1)"
        '';
      };
    };
}
