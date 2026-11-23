{ inputs, ... }:

{
  imports = [
    inputs.mangowm.nixosModules.mango

    ./mango.nix
  ];
}
