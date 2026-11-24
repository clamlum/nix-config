{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.mako =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.mako
        pkgs.libnotify
      ];

      services.mako = {
        enable = true;

        settings = {
          sort = "-time";
          layer = "overlay";
          background-color = "#1f2134";
          width = 300;
          height = 110;
          border-size = 2;
          border-color = "#4ea1ff";
          border-radius = 0;
          icons = 0;
          max-icon-size = 64;
          default-timeout = 5000;
          ignore-timeout = 1;
          font = "DejaVuSansM Nerd Font Mono 12";
          anchor = "top-left";

          "urgency=low" = {
            border-color = "#6c8aff";
          };

          "urgency=normal" = {
            border-color = "#4ea1ff";
          };

          "urgency=high" = {
            border-color = "#b4d7ff";
            default-timeout = 0;
          };

          "category=mpd" = {
            default-timeout = 2000;
            group-by = "category";
          };
        };
      };
    };

  flake.modules.nixos.mako = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.mako
    ];
  };
}
