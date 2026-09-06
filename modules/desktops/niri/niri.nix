{ pkgs, lib, username, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.systemPackages = [
    pkgs.swaybg
    pkgs.wtype

    (let
      version = "0.8.1";
    in pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "xwayland-satellite";
      inherit version;
      src = pkgs.fetchFromGitHub {
        owner = "Supreeeme";
        repo = "xwayland-satellite";
        tag = "v${finalAttrs.version}";
        hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
      };
      postPatch = ''
        substituteInPlace resources/xwayland-satellite.service \
          --replace-fail '/usr/local/bin' "$out/bin"
      '';
      cargoHash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
      nativeBuildInputs = [
        pkgs.installShellFiles
        pkgs.makeBinaryWrapper
        pkgs.pkg-config
        pkgs.rustPlatform.bindgenHook
      ];
      buildInputs = [
        pkgs.libxcb
        pkgs.libxcb-cursor
      ];
      buildNoDefaultFeatures = true;
      buildFeatures = lib.optional true "systemd";
      outputs = [ "out" "man" ];
      doCheck = false;
      postInstall = ''
        installManPage --name xwayland-satellite.1 xwayland-satellite.man
      '' + ''
        install -Dm0644 resources/xwayland-satellite.service -t $out/lib/systemd/user
      '';
      postFixup = ''
        wrapProgram $out/bin/xwayland-satellite \
          --prefix PATH : "${lib.makeBinPath [ pkgs.xwayland ]}"
      '';
      meta = {
        description = "Xwayland outside your Wayland compositor";
        homepage = "https://github.com/Supreeeme/xwayland-satellite";
        license = lib.licenses.mpl20;
        mainProgram = "xwayland-satellite";
        platforms = lib.platforms.linux;
      };
    }))
  ];

  home-manager.users.${username}.home.file.".config/niri/config.kdl".source =
    ../../../resources/niri/niri.kdl;
}
