{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [
      "hf.co/adilkairolla/zeta-2.1-GGUF:Q4_K_M"
    ];

    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "1m";
      OLLAMA_FLASH_ATTENTION = "1";

      OLLAMA_MAX_LOADED_MODELS = "1";
      OLLAMA_NUM_PARALLEL = "1";

      OLLAMA_GPU_OVERHEAD = "1073741824";
    };
  };
}
