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

  fileSystems."/mnt/Videos" = {
    device = "/dev/disk/by-uuid/897c80cf-612b-44ae-826a-575632dce4e0";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=no"
      "nofail"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  services.udev.extraHwdb = ''
    evdev:name:libvirtualhid Mouse:*
     MOUSE_DPI=10000@1000
  '';

  powerManagement.cpuFreqGovernor = "performance";

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

  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };

  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "0";
    XRT_COMPOSITOR_COMPUTE = "1";
    WMR_HANDTRACKING = "0";
  };

  services.udev.packages = [ pkgs.monado ];
}
