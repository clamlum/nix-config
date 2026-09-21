{
  pkgs,
  lib,
  username,
  inputs,
  device,
  ...
}:
let
  smithay-spicy-src = pkgs.fetchFromGitHub {
    owner = "losnoco";
    repo = "smithay";
    rev = "spicy-master";
    hash = "sha256-8DJkMXCfXxn3MBanScx7W38lFJFzYd53cnUnyO1NJxk=";
  };

  niri-spicy = pkgs.niri.overrideAttrs (old: rec {
    pname = "niri-spicy";
    version = "spicy-main-unstable";

    src = pkgs.fetchFromGitHub {
      owner = "losnoco";
      repo = "niri";
      rev = "spicy-main";
      hash = "sha256-fV9z8VZ7qvCiJ3ZjYwGb0tjEb9dB3AEma/rKEfKm0MU=";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-hD6+CNjITci+T1TIDy/YWtMWbR6icXexbXynSdDiL6c=";
    };

    postPatch = (old.postPatch or "") + ''
      cp -r --no-preserve=mode,ownership ${smithay-spicy-src} "$NIX_BUILD_TOP/smithay"
      chmod -R u+w "$NIX_BUILD_TOP/smithay"
    '';

    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      pkgs.cmake
      pkgs.rustPlatform.bindgenHook
    ];

    buildInputs = (old.buildInputs or []) ++ [
      pkgs.shaderc
      pkgs.cairo
      pkgs.glib
      pkgs.pango
      pkgs.libdisplay-info
    ];

    doInstallCheck = false;
  });
in

{
  programs.niri = {
    enable = true;
    package = if device == "nixos" then niri-spicy else pkgs.niri;
  };

  services.displayManager.defaultSession = lib.mkForce "niri";

  environment.systemPackages = [
    pkgs.swaybg
    pkgs.wtype
    inputs.xwayland-satellite.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${username}.home.file = {
    ".config/niri/config.kdl".source = ../../../resources/niri/niri.kdl;
    ".config/niri/device.kdl".source = lib.mkMerge [
      (lib.mkIf (device == "nixos") ../../../resources/niri/nixos.kdl)
      (lib.mkIf (device == "asahi") ../../../resources/niri/asahi.kdl)
      (lib.mkIf (device == "surface") ../../../resources/niri/surface.kdl)
    ];
  };
}
