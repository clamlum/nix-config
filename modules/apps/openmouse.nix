{
  flake.modules.nixos.openmouse =
    { lib, pkgs, ... }:
    let
      openmouse-bridge = pkgs.rustPlatform.buildRustPackage rec {
        pname = "openmouse-bridge";
        version = "1.0.0-beta.18";

        src = pkgs.fetchFromGitHub {
          owner = "OpenMouse-Project";
          repo = "OpenMouse-Bridge";
          rev = "main";
          hash = "sha256-2ft2cBu3O23+07NHcQ0ngA+3ZqNx+NoquEvN64auNB8=";
        };

        cargoLock.lockFile = "${src}/Cargo.lock";

        nativeBuildInputs = with pkgs; [
          pkg-config
          wrapGAppsHook3
        ];

        buildInputs = with pkgs; [
          udev
          gtk3
          glib
          cairo
          pango
          gdk-pixbuf
          atk
          libayatana-appindicator
          libxkbcommon
          libxcb
          libX11
        ];

        runtimeLibs = with pkgs; [
          libglvnd
          libxkbcommon
          wayland
          libX11
          libXcursor
          libXi
          libXrandr
          libayatana-appindicator
        ];

        preFixup = ''
          gappsWrapperArgs+=(
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
          )
        '';

        doCheck = false;

        meta.mainProgram = "openmouse-bridge";
      };
    in
    {
      environment.systemPackages = [ openmouse-bridge ];

      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "openmouse-udev-rules";
          destination = "/etc/udev/rules.d/70-openmouse.rules";
          text = ''
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess"
          '';
        })
      ];

      systemd.user.services.openmouse-bridge = {
        description = "OpenMouse Bridge";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = lib.getExe openmouse-bridge;
          Restart = "on-failure";
          RestartSec = 3;
        };
      };
    };
}
