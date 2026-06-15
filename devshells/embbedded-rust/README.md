# esp-rs-nix

A modern Nix flake for ESP32 Rust development with Xtensa and RISC-V targets.

## Features

- Complete ESP32 Rust toolchain (ESP-RS + GCC cross-compilers)
- Support for all ESP32 variants (ESP32, ESP32-S2, ESP32-S3, ESP32-C3, etc.)
- Multiple development shells (default, minimal, CI)
- Automatic cargo configuration for ESP targets
- Built-in development tools (espflash, probe-rs, cargo-generate)
- Cachix binary cache support
- Project template included
- Automated checks and formatting

## Quick Start

```bash
# Start developing immediately
nix develop

# Or use the template for a new project
nix flake new -t git+https://git.sr.ht/~olk/esp-rs-nix my-esp-project
cd my-esp-project
nix develop
```

## Usage

### Development Shells

```bash
# Full development environment (default)
nix develop

# Minimal environment (just toolchain)
nix develop .#minimal

# CI environment (for builds/testing)
nix develop .#ci
```

### Building ESP32 Projects

The development shell automatically configures cargo for ESP32 targets:

```bash
# Generate a new project
cargo generate esp-rs/esp-template

# Build for ESP32-S3 (default target)
cargo build

# Build for specific targets
cargo build --target xtensa-esp32-none-elf
cargo build --target riscv32imc-esp-espidf

# Flash and monitor
cargo run
```

### Supported Targets

- `xtensa-esp32-none-elf` - ESP32
- `xtensa-esp32s2-none-elf` - ESP32-S2
- `xtensa-esp32s3-none-elf` - ESP32-S3
- `riscv32imc-esp-espidf` - ESP32-C3/C6/H2

## Architecture

This flake provides a complete ESP32 development environment by:

1. **Centralized version management** - All toolchain versions in `versions.nix`
2. **Modular packaging** - Separate derivations for Rust and GCC toolchains
3. **Multiple shells** - Different environments for different use cases
4. **Automated setup** - Cargo configuration and environment variables
5. **Quality checks** - Toolchain validation and code formatting

## Development

```bash
# Check toolchain works
nix flake check

# Format nix files
nix fmt

# Update dependencies
nix flake update
```

## Notes

- **no_std only**: For `esp-hal` based applications, not `esp-idf`
- **x86_64 Linux**: Currently hardcoded for this architecture
- **Binary cache**: Uses Cachix for faster builds

## Contributing

PRs welcome! This project aims to provide a reliable, modern Nix environment for ESP32 Rust development.

## License

MIT License - see LICENSE file for details.
