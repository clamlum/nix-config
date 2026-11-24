{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.base = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "25.11";

    home.file.".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';

    home.file.".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';
  };

  flake.modules.nixos.home = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.base
    ];
  };
}
