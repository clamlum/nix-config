{ config, ... }:
let
  topConfig = config;
in
{
  flake.wrappers.git =
    {
      config,
      pkgs,
      wlib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.git ];

      runtimePkgs = [ pkgs.openssh ];

      constructFiles.gitignore = {
        relPath = "gitignore";
        content = ''
          .DS_Store
          ._.DS_Store
        '';
      };

      settings = {
        user = {
          name = "clamlum";
          email = "clamlum2@gmail.com";
          signingKey = "~/.ssh/id_ed25519.pub";
        };
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;
        core.excludesFile = config.constructFiles.gitignore.path;
      };
    };

  flake.modules.generic.git = {
    imports = [
      topConfig.flake.wrappers.git.install
    ];

    wrappers.git.enable = true;
  };
}
