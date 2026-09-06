{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "uas" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@log" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" ];
  };

  fileSystems."/.swapvol" = {
    device = "/dev/disk/by-uuid/659b082e-de60-4be0-96b6-c6d22078befe";
    fsType = "btrfs";
    options = [ "subvol=@swap" ];
  };

  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      size = 8192;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
