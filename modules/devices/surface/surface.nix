{ pkgs, lib, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "surface";

  nixpkgs.overlays = [
    inputs.custom-pkgs.overlays.default
    (final: prev: {
      iptsd = prev.iptsd.overrideAttrs (old: {
        version = "3.1.0-lentz";
        src = final.fetchFromGitHub {
          owner = "alex-lentz";
          repo = "iptsd";
          rev = "master";
          hash = "sha256-wN9dg8W0uuDK9H/6z2NyAEinGAIZlEDZuMsPMBeq9pw=";
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

  hardware.deviceTree.overlays = [
    {
      name = "enable-iris";
      dtsText = ''
        /dts-v1/;
        /plugin/;
        / {
          compatible = "<same as in the flake's other overlays>";
        };
        &{/soc@0/video-codec@aa00000} {
          status = "okay";
        };
      '';
    }
  ];

  specialisation = lib.mkForce { };

  hardware.graphics.enable = true;

  services.iptsd.enable = true;

  systemd.tpm2.enable = false;

  boot.kernelModules = [ "qcom_pd_mapper" ];

  services.upower.enable = true;

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  system.stateVersion = "26.11";
}
