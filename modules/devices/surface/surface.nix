{ pkgs, lib, inputs, ... }:
let
  sl7-firmware = pkgs.callPackage ./firmware.nix { };
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "surface";

  nixpkgs.overlays = [
    inputs.custom-pkgs.overlays.default
    (final: prev: {
      iptsd = prev.iptsd.overrideAttrs (old: {
        version = "3.1.0-fork";
        src = final.fetchFromGitHub {
          owner = "andreasbjorshol";
          repo = "iptsd";
          rev = "master";
          hash = "sha256-qBFcjLICzlqv0M8qT3g3RmEqrr8hP/y7saAoffT5C3U=";
        };
        patches = [ ];
        env = (old.env or { }) // {
          PKG_CONFIG_SYSTEMD_SYSTEMDSLEEPDIR =
            "${placeholder "out"}/lib/systemd/system-sleep";
        };
      });
    })
  ];

  boot.loader.systemd-boot.extraFiles = lib.mkForce (
    let
      fw = "firmware/qcom/x1e80100/microsoft/Romulus";
      src = "${pkgs.x1e80100-firmware}/lib/firmware/qcom/x1e80100/microsoft/Romulus";
    in {
      "${fw}/qcadsp8380.mbn"  = "${src}/qcadsp8380.mbn";
      "${fw}/adsp_dtbs.elf"   = "${src}/adsp_dtbs.elf";
      "${fw}/qccdsp8380.mbn"  = "${src}/qccdsp8380.mbn";
      "${fw}/cdsp_dtbs.elf"   = "${src}/cdsp_dtbs.elf";
    }
  );

  powerManagement.resumeCommands = ''
    ${pkgs.systemd}/bin/udevadm trigger --subsystem-match=hidraw --action=add
  '';

  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };

  hardware.firmware = [ sl7-firmware ];

  hardware.deviceTree.overlays = [
    {
      name = "enable-iris";
      dtsText = ''
        /dts-v1/;
        /plugin/;
        / {
          compatible = "microsoft,romulus13";
        };
        &{/soc@0/video-codec@aa00000} {
          status = "okay";
        };
      '';
    }
  ];

  specialisation = lib.mkForce { };

  services.iptsd.enable = true;

  systemd.tpm2.enable = false;

  boot.kernelModules = [ "qcom_pd_mapper" ];

  environment.systemPackages = [
    pkgs.brightnessctl
    pkgs.btop
    pkgs.cifs-utils
  ];

  services.upower.enable = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

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

  system.stateVersion = "26.11";
}
