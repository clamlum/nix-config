{
  flake.modules.nixos.obs =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          obs-vaapi
          obs-gstreamer
          obs-vkcapture
        ];
      };

      environment.systemPackages = [
        pkgs.libva-vdpau-driver
        pkgs.libva-utils
        pkgs.ffmpeg-full
      ];
    };
}
