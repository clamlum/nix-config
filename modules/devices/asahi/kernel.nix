{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:
let
  crossPkgs = import pkgs.path {
    localSystem = "x86_64-linux";
    crossSystem = "aarch64-linux";
    overlays = [ inputs.apple-silicon-support.overlays.default ];
  };
in
{
  boot.kernelPackages = lib.mkForce crossPkgs.linux-asahi;

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "pc";
      system = "x86_64-linux";
      sshUser = "${username}";
      sshKey = "/home/${username}/.ssh/id_ed25519";
      maxJobs = 16;
      speedFactor = 4;
      supportedFeatures = [
        "big-parallel"
        "kvm"
      ];
    }
  ];

  nix.settings.builders-use-substitutes = true;
}
