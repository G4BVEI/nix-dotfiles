{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm"; # Use AMD ROCm backend

    # FORCE GPU COMPATIBILITY FOR RX 7700S (gfx1102)
    # This tells ROCm to pretend the card is a slightly older, well-supported version.
    rocmOverrideGfx = "11.0.0";

    # Optional: Pre-load a model so it starts faster
    loadModels = [ "qwen2.5-coder:7b" ];
  };

  # 4. System Packages
  environment.systemPackages = with pkgs; [
    ollama-rocm # The ROCm-specific Ollama package
    rocmPackages.rocminfo # Tool to verify your GPU is detected
  ];
}
