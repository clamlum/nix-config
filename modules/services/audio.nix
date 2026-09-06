{
  pkgs,
  lib,
  device,
  ...
}:

{
  security.rtkit.enable = true;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.systemPackages = [
    pkgs.wireplumber
    pkgs.pavucontrol
    pkgs.alsa-utils
  ];

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "rtprio";
      type = "soft";
      value = "95";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "hard";
      value = "95";
    }
    {
      domain = "@audio";
      item = "memlock";
      type = "soft";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "memlock";
      type = "hard";
      value = "unlimited";
    }
  ];

  users.users."clamt".extraGroups = [ "audio" ];

  boot.kernel.sysctl = {
    "kernel.sched_rt_runtime_us" = -1;
  };

  services.pipewire.wireplumber.extraConfig."51-bluez-config" = lib.mkIf (device == "asahi") {
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
}
