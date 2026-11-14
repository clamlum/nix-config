{ lib, ... }:

{
  options.vars = {
    wallpaperPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the wallpaper image";
    };
    configPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the nix-config directory";
    };
  };

  config = {
    vars.wallpaperPath = "/home/clamt/Pictures/wallpapers/353544.jpg";
    vars.configPath = "$HOME/nix-config";
  };
}
