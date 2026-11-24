{ inputs, ... }:
let
  mkStable =
    pkgs:
    import inputs.nixpkgs-stable {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
in
{
  flake.modules.generic.pkgs-global =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.git
        pkgs.python3
        pkgs.rustc
        pkgs.rustPlatform.rustLibSrc
        pkgs.cargo

        pkgs.mpv
        pkgs.ffmpeg

        pkgs.bitwarden-desktop

        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  flake.modules.nixos.pkgs-linux =
    { pkgs, ... }:
    let
      stable = mkStable pkgs;
    in
    {
      environment.systemPackages = [
        pkgs.easyeffects
        pkgs.playerctl
        pkgs.picard
        pkgs.libsForQt5.qt5ct

        pkgs.wl-clipboard
        pkgs.p7zip
        pkgs.nautilus

        pkgs.antigravity-cli

        stable.libreoffice-qt
      ];
    };

  flake.modules.nixos.pkgs-nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.gradle_9
        pkgs.jdk25
        pkgs.idea
        pkgs.localsend
        pkgs.ddcutil
        pkgs.openrgb
      ];
    };

  flake.modules.nixos.pkgs-laptop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.vesktop
        pkgs.prismlauncher
      ];
    };
}
