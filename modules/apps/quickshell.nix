{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.quickshell =
    { osConfig, pkgs, ... }:
    let
      quickshell-wrapped = pkgs.symlinkJoin {
        name = "quickshell-wrapped";
        paths = [ pkgs.quickshell ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/qs --unset QT_QPA_PLATFORMTHEME
          wrapProgram $out/bin/quickshell --unset QT_QPA_PLATFORMTHEME
        '';
      };
    in
    {
      home.packages = [
        quickshell-wrapped
        pkgs.jq
        pkgs.inotify-tools
      ];

      home.file.".config/quickshell" = {
        source = builtins.filterSource (
          path: type: baseNameOf path != ".qmlls.ini"
        ) ../../resources/quickshell;
        recursive = true;
      };

      systemd.user.sessionVariables = {
        WALLPAPER_PATH = osConfig.vars.wallpaperPath;
      };
    };

  flake.modules.nixos.quickshell = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.quickshell
    ];
  };
}
