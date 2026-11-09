{ pkgs, ... }:
let
  vencord-pr = pkgs.callPackage (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/19375cd0259c026cbe65f239d885b41babc2e801/pkgs/by-name/ve/vencord/package.nix";
    hash = "sha256-1G89n8KGxfJWE62yI07hGqm+F/6+Z/VE2w4lm6X+YlI=";
  }) { };
in
{
  environment.systemPackages = [
    (pkgs.discord.override {
      withVencord = true;
      vencord = vencord-pr;
      # withOpenASAR = true;
    })
  ];
}
