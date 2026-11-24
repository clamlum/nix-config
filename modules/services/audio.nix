{
  flake.modules.nixos.audio =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;

      services.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
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
    };
}
