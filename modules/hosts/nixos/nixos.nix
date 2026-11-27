{ inputs, config, ... }:
let
  inherit (config.flake.meta) username;
  inherit (config.flake.modules) generic nixos;
in
{
  flake.modules.nixos.nixos =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager

        # Base
        generic.nix-settings
        generic.pkgs-global
        nixos.configuration
        nixos.variables
        nixos.home
        nixos.pkgs-linux
        nixos.pkgs-nixos

        # Apps & Terminals
        generic.zed
        generic.kopuz
        nixos.ladybird
        nixos.wezterm
        nixos.android
        nixos.gaming
        nixos.obs
        nixos.discord
        nixos.openmouse
        nixos.fuzzel
        nixos.quickshell

        # Shell
        generic.zsh
        generic.git
        generic.nix-shell

        # Desktops & DM
        nixos.mango
        nixos.greetd

        # Services
        nixos.fonts
        nixos.audio
        nixos.gtk
        nixos.qt
        nixos.libinput
        nixos.icons
        nixos.mako
      ];

      home-manager.users.${username}.home.file.".config/mango/device.conf".source =
        ../../../resources/mango/nixos.conf;

      system.stateVersion = "25.11";
      greeter.scale = "1";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      fileSystems."/mnt/Games" = {
        device = "/dev/disk/by-uuid/8ed76560-53e7-4b1d-99df-80f4e0f0d27d";
        fsType = "btrfs";
        options = [
          "compress=zstd"
          "noatime"
          "nofail"
        ];
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

        settings = {
          capture = "kms";
          output_name = "DP-1";
          csrf_allowed_origins = "https://192.168.2.1:47990";
        };
      };

      services.udev.extraHwdb = ''
        evdev:name:libvirtualhid Mouse:*
         MOUSE_DPI=10000@1000
      '';

      powerManagement.cpuFreqGovernor = "performance";

      boot.supportedFilesystems = [ "nfs" ];

      environment.systemPackages = [ pkgs.cifs-utils ];
      fileSystems."/mnt/share" = {
        device = "192.168.2.20:/mnt/drive/media/library";
        fsType = "nfs4";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=600"
          "x-systemd.mount-timeout=10s"
          "nofail"
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

      services.tailscale.enable = true;

      programs.kdeconnect.enable = true;

      hardware.bluetooth.enable = true;

      services.blueman.enable = true;

      services.udev.extraRules = ''
        KERNEL=="hidraw*", ATTRS{idVendor}=="3367", ATTRS{idProduct}=="1970", GROUP="input", MODE="0660"
      '';

      users.users.${username}.extraGroups = [ "input" ];
    };

  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ nixos.nixos ];
  };
}
