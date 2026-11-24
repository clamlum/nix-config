{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.wezterm = {
    programs.wezterm.enable = true;

    home.file.".wezterm.lua".source = ../../resources/wezterm/wezterm.lua;
  };

  flake.modules.nixos.wezterm = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.wezterm
    ];
  };
}
