{ inputs, config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.nixos.mango =
    { pkgs, lib, ... }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];

      programs.mango.enable = true;

      environment.systemPackages = [
        pkgs.grim
        pkgs.slurp
        pkgs.swaybg
        pkgs.wtype
      ];

      services.logind.settings.Login.HandleLidSwitch = "suspend";

      systemd.user.targets.mango-session = {
        description = "mango compositor session";
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

        config.mango = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };

        wlr.settings.screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt 'Share: '";
        };
      };

      home-manager.users.${username} = {
        home.file = {
          ".config/mango/config.conf".source = ../../resources/mango/config.conf;
        };

        services.swayidle = {
          enable = true;
          events = {
            lock = "${pkgs.quickshell}/bin/qs ipc call lock activate";
            before-sleep = "${pkgs.quickshell}/bin/qs ipc call lock activate";
          };
          timeouts = lib.mkDefault [ ];
        };
      };
    };
}
