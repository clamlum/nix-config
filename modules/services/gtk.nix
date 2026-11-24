{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.nixos.gtk =
    { pkgs, ... }:
    {
      programs.dconf.enable = true;

      environment.systemPackages = [
        pkgs.glib
        pkgs.gsettings-desktop-schemas
        pkgs.gnome-themes-extra
        pkgs.adwaita-icon-theme
      ];

      home-manager.users.${username}.gtk.gtk2.force = true;
    };
}
