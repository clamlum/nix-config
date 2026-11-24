{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.icons =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.kdePackages.breeze
        pkgs.adwaita-icon-theme
        pkgs.dconf
      ];

      home.pointerCursor = {
        enable = true;
        name = "breeze_cursors";
        package = pkgs.kdePackages.breeze;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };

        gtk4 = {
          theme = null;
          extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
        };
      };
    };

  flake.modules.nixos.icons = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.icons
    ];
  };
}
