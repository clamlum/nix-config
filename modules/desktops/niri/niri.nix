{
  pkgs,
  lib,
  username,
  inputs,
  device,
  ...
}:
let
  niri-spicy = pkgs.niri.overrideAttrs (old: {
    pname = "niri-spicy";
    version = "spicy-main-${inputs.niri-spicy-src.shortRev or "dirty"}";

    src = inputs.niri-spicy-src;

    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = "${inputs.niri-spicy-src}/Cargo.lock";
      allowBuiltinFetchGit = true;
    };

    postPatch = (old.postPatch or "") + ''
      cp -r --no-preserve=mode,ownership ${inputs.smithay-spicy-src} "$NIX_BUILD_TOP/smithay"
    '';

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      pkgs.cmake
      pkgs.rustPlatform.bindgenHook
    ];

    buildInputs = (old.buildInputs or [ ]) ++ [
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
