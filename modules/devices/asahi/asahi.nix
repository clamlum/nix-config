{ pkgs, inputs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asahi";
  # networking.networkmanager.wifi.backend = "iwd";

  services.libinput.enable = true;

  system.stateVersion = "26.11";

  imports = [
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
  ];

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
}
