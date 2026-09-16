{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./overlays/discord.nix)
  ];

  environment.systemPackages = with pkgs; [
    (discord.override {
      withVencord = true;
      withOpenASAR = true;
    })
  ];
}
