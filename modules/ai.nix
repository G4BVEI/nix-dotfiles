{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;

    # INSTEAD of 'acceleration = "rocm"', use the specific package:
    package = pkgs.ollama-rocm; # For AMD GPU

    # Environment variables to force GPU compatibility for RX 7700S

    # Optional: Pre-load a model
    loadModels = [ "qwen2.5-coder:7b" ];
  };

  # 4. System Packages
  environment.systemPackages = with pkgs; [
    ollama-rocm
    rocmPackages.rocminfo
  ];
}
