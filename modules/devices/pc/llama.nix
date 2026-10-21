{ pkgs, lib,username, ... }: {
  hardware.graphics.enable = true;

  users.users.llama-cpp = {
    isSystemUser = true;
    group = "llama-cpp";
    extraGroups = [ "render" "video" ];
  };
  users.groups.llama-cpp = { };
  users.users.${username}.extraGroups = [ "llama-cpp" ];

  systemd.tmpfiles.rules = [
    "d /srv/llama-cache 2775 llama-cpp llama-cpp -"
  ];

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    settings = {
      host = "0.0.0.0";
      port = 8080;
      cache-reuse = 256;
      models-max = 2;
      models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
        "*" = {
          n-gpu-layers = "99";
          ctx-size = "8192";
          cache-reuse = "256";
          parallel = "1";
        };
        "zeta2.1" = {
          hf-repo = "adilkairolla/zeta-2.1-GGUF";
          hf-file = "zeta-2.1-Q4_K_M.gguf";
        };
        "gpt-oss-20b" = {
          hf-repo = "ggml-org/gpt-oss-20b-GGUF";
          hf-file = "gpt-oss-20b-MXFP4.gguf";
          ctx-size = "32768";
          jinja = "true";
          temp = "1.0";
          top-p = "1.0";
          top-k = "0";
          min-p = "0.0";
        };
      };
    };
  };

  systemd.services.llama-cpp = {
    environment = {
      LLAMA_CACHE = "/srv/llama-cache";
      XDG_CACHE_HOME = "/var/cache/llama-cpp";
      MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
    };
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "llama-cpp";
      Group = "llama-cpp";
      CacheDirectory = "llama-cpp";
      ReadWritePaths = [ "/srv/llama-cache" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
