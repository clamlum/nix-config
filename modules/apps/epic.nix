{ fetchurl, appimageTools }:

let
  pname = "epic-games-launcher";
  version = "0.95.2";

  src = fetchurl {
    url = "https://content-download-egs.distro.on.epicgames.com/Builds/EGLv2/0.95.2%2Bgfa9ad49/Linux/EpicGamesLauncher-x86_64.AppImage?launcherfilename=EpicGamesLauncher-x86_64.AppImage";
    sha256 = "sha256-cGYVnsmHr83CcGnwcLRWvbmoBb1fAhFKp62G5VWcv9U=";
  };
in

appimageTools.wrapType2 { inherit pname version src; }
