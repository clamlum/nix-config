{ pkgs, lib, device, username, ... }:
{
  programs.mango.enable = true;

  environment.systemPackages = [
    pkgs.grim pkgs.slurp
  ];

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

  home-manager.users.${username}.home.file = {
    ".config/mango/config.conf".source = ../../../resources/mango/config.conf;
    ".config/mango/device.conf".source = lib.mkMerge [
      (lib.mkIf (device == "nixos") ../../../resources/mango/nixos.conf)
      (lib.mkIf (device == "asahi") ../../../resources/mango/asahi.conf)
      (lib.mkIf (device == "surface") ../../../resources/mango/surface.conf)
    ];
  };
}
