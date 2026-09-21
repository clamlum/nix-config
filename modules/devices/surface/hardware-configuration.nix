{ lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/.swapvol" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@swap" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd"
        "noatime"
      ];
    };

  swapDevices = [
    {
      device = "/.swapvol/swapfile";
      size = 8192;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
