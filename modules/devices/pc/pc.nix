{
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.11";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/8f56f8cf-1cd4-4dab-a2fc-37c29f4e6ed5";
    fsType = "ext4";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.initrd.availableKernelModules = lib.mkForce [
    "nvme"
    "xhci_pci"
    "xhci_hcd"
    "ahci"
    "usbhid"
    "sd_mod"
    "ext4"
    "tpm-crb"
  ];

  boot.blacklistedKernelModules = [
    "esp4"
    "esp6"
    "rxrpc"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
    allowedUDPPorts = [
      8800
      25565
    ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine;
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "12.0.1";
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
  };

  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/music" = {
    device = "//host.media.local/music";
    fsType = "cifs";
    options = [
      "credentials=/etc/secrets/smb"
      "nofail"
      "x-systemd.automount"
      "x-systemd.mount-timeout=5"
      "soft"
      "uid=1000"
      "gid=100"
      "file_mode=0755"
      "dir_mode=0755"
    ];
  };

  hardware.i2c.enable = true;
}
