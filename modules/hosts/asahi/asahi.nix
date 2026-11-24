{ inputs, config, ... }:
let
  inherit (config.flake.meta) username;
  inherit (config.flake.modules) generic nixos;
in
{
  flake.modules.nixos.asahi =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.apple-silicon-support.nixosModules.apple-silicon-support

        # Base
        generic.nix-settings
        generic.pkgs-global
        nixos.configuration
        nixos.variables
        nixos.home
        nixos.pkgs-linux
        nixos.pkgs-laptop

        # Apps & Terminals
        generic.zed
        generic.kopuz
        nixos.wezterm
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
        nixos.wireguard
      ];

      home-manager.users.${username} = {
        home.file.".config/mango/device.conf".source = ../../../resources/mango/asahi.conf;
        services.swayidle.timeouts = [
          {
            timeout = 300;
            command = "${pkgs.quickshell}/bin/qs ipc call lock activate";
          }
          {
            timeout = 310;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "asahi";

      services.libinput.enable = true;

      system.stateVersion = "26.11";
      greeter.scale = "1.8";

      services.pipewire.wireplumber.extraConfig."51-bluez-config" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
          "bluez5.codecs" = [
            "sbc"
            "sbc_xq"
            "aac"
          ];
        };
      };

      nixpkgs.overlays = [ inputs.apple-silicon-support.overlays.apple-silicon-overlay ];

      hardware.asahi.enable = true;

      hardware.apple.touchBar = {
        enable = true;
        package = inputs.not-quite-tiny-dfr.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      hardware.asahi.peripheralFirmwareDirectory = inputs.asahi-firmware;

      environment.systemPackages = [
        pkgs.brightnessctl
        pkgs.btop
        pkgs.distrobox
        pkgs.cifs-utils
      ];

      services.upower.enable = true;

      hardware.bluetooth.enable = true;

      services.blueman.enable = true;

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      services.cloudflare-warp.enable = true;

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="apple-panel-bl", \
          RUN+="${pkgs.coreutils}/bin/chown root:video /sys/class/backlight/%k/brightness", \
          RUN+="${pkgs.coreutils}/bin/chmod 777 /sys/class/backlight/%k/brightness"

        ACTION=="add", SUBSYSTEM=="leds", KERNEL=="kbd_backlight", \
          RUN+="${pkgs.coreutils}/bin/chown root:video /sys/class/leds/%k/brightness", \
          RUN+="${pkgs.coreutils}/bin/chmod 777 /sys/class/leds/%k/brightness"
      '';

      programs.virt-manager.enable = true;

      programs.moonlight-qt.enable = true;

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

      hardware.graphics.enable = true;

      services.tailscale.enable = true;

      programs.kdeconnect.enable = true;
    };

  flake.nixosConfigurations.asahi = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [ nixos.asahi ];
  };
}
