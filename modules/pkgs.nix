{
  pkgs,
  nixpkgs-stable,
  device,
  inputs,
  ...
}:

let
  stable = import nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  globalPkgs = [
    pkgs.git
    pkgs.python3
    pkgs.rustc
    pkgs.rustPlatform.rustLibSrc
    pkgs.cargo

    pkgs.mpv
    pkgs.ffmpeg

    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  linuxPkgs = [
    pkgs.easyeffects
    pkgs.playerctl
    pkgs.picard
    pkgs.libsForQt5.qt5ct

    pkgs.wl-clipboard
    pkgs.p7zip
    pkgs.nautilus
  ];

  nixosPkgs = [
    pkgs.gradle_9
    pkgs.jdk25
    pkgs.idea
    pkgs.localsend
    pkgs.ddcutil
    pkgs.gns3-server
  ];

  laptopPkgs = [
    pkgs.vesktop
    pkgs.prismlauncher
    stable.libreoffice-qt
    pkgs.gns3-gui
  ];

  macbookPkgs = [
    pkgs.vesktop
    pkgs.gradle_9
    pkgs.jdk25
    pkgs.jetbrains.idea
    pkgs.prismlauncher
    pkgs.libreoffice-bin
    stable.virt-manager
  ];
in

{
  environment.systemPackages =
    [ ]
    ++ globalPkgs
    ++ (
      if device == "nixos" then
        nixosPkgs ++ linuxPkgs
      else if device == "asahi" || device == "surface" then
        laptopPkgs ++ linuxPkgs
      else if device == "macbook" then
        macbookPkgs
      else
        linuxPkgs
    );

  nixpkgs = {
    config.allowUnfree = true;
  };

  nixpkgs.overlays =
    [ ]
    ++ (
      if device != "macbook" then
        [
          (import apps/overlays/idea.nix)
        ]
      else
        [ ]
    );
}
