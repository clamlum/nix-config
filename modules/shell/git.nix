{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "clamlum";
        user.email = "clamlum2@gmail.com";
        gpg.format = "ssh";
      };

      signing = {
        key = "~/.ssh/id_ed25519.pub";
        signByDefault = true;
      };

      ignores = [
        ".DS_Store"
        "._.DS_Store"
      ];
    };
  };

  flake.modules.generic.git = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.git
    ];
  };
}
