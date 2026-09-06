self: super:
let
  idea-pkg = super.jetbrains.idea;
  libs = with super; [
    mesa
    libGL
    libGLU
    libglvnd
    glfw
    libX11
    libXext
    libXrandr
    libXcursor
    libXi
    libXxf86vm
    openal
    alsa-lib
    libpulseaudio
  ];
in
{
  idea = super.symlinkJoin {
    name = "idea-with-gl";
    paths = [ idea-pkg ];
    nativeBuildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/idea \
        --prefix LD_LIBRARY_PATH : ${super.lib.makeLibraryPath libs}
    '';
  };
}
