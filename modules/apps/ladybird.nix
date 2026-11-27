{ config, ... }:
{
  flake.overlays.ladybird = final: _prev: {
    ladybird =
      let
        # https://github.com/NixOS/nixpkgs/pull/584562
        prSrc = final.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "0b6d6286c109f720355fecf3986c6808cc06063c";
          sparseCheckout = [ "pkgs/by-name/la/ladybird" ];
          hash = "sha256-zngk2fEW98LYyarV79KBJKncwxsNZYHsPHwNbG74XR8=";
        };
      in
      final.callPackage "${prSrc}/pkgs/by-name/la/ladybird/package.nix" { };
  };

  flake.modules.nixos.ladybird = {
    nixpkgs.overlays = [ config.flake.overlays.ladybird ];

    programs.ladybird.enable = true;
  };
}
