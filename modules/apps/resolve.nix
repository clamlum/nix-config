{
  pkgs,
  lib,
  ...
}:
let
  resolveEnv = {
    ROC_ENABLE_PRE_VEGA = "1";
    RUSTICL_ENABLE = "amdgpu,amdgpu-pro,radv,radeon,radeonsi";
    DRI_PRIME = "1";
    QT_QPA_PLATFORM = "xcb";
  };

  davinci-resolve-fixed =
    let
      packageNixPath = "${pkgs.path}/pkgs/by-name/da/davinci-resolve/package.nix";
      patched =
        builtins.replaceStrings
          [
            "sha256-bQ4Yag4xfIF9Fs0UVKaYFhObMsAof5n+Sy4osw35a9g="
            "sha256-D5RjUukwKMpULrDfMJOPsPWW9FxhQ/IUMh76u5JLytA="
          ]
          [
            "sha256-+3SB32EHpH9/0hM3h8CrO6f7V4ZAmxUFh3P8m6QDeO0="
            lib.fakeHash
          ]
          (builtins.readFile packageNixPath);
    in
    pkgs.callPackage (builtins.toFile "davinci-resolve-package.nix" patched) {
      studioVariant = false;
    };

  davinci-resolve-wrapped = pkgs.symlinkJoin {
    name = "davinci-resolve-wrapped";
    paths = [ davinci-resolve-fixed ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/davinci-resolve \
        ${lib.concatStringsSep " " (
          lib.mapAttrsToList (name: value: "--set ${name} '${value}'") resolveEnv
        )}

      rm -f $out/share/applications/*.desktop
      for f in ${davinci-resolve-fixed}/share/applications/*.desktop; do
        substitute "$f" "$out/share/applications/$(basename "$f")" \
          --replace "${davinci-resolve-fixed}/bin/davinci-resolve" "$out/bin/davinci-resolve"
      done
    '';
  };
in
{
  environment.systemPackages = [
    davinci-resolve-wrapped
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa.opencl
    ];
  };
}
