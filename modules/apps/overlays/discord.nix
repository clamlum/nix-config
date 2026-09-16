final: prev:
let
  libs = with prev; [
    nspr
    nss
    nssTools
    alsa-lib
    libpulseaudio
    pipewire
    libGL
    libGLU
    mesa
    libva
    libva-utils
    libvdpau
    vulkan-loader
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    libXxf86vm
    wayland
    libxkbcommon
    glib
    gtk3
    gdk-pixbuf
    atk
    at-spi2-core
    at-spi2-atk
    pango
    cairo
    harfbuzz
    dbus
    expat
    fontconfig
    freetype
    zlib
    curl
    cups
    libdrm
    udev
    stdenv.cc.cc.lib
    libsecret
    libuuid
    krb5
    libgbm
  ];
in
{
  discord = prev.discord.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];

    buildCommand = old.buildCommand + ''
      wrapProgram $out/bin/discord \
        --prefix LD_LIBRARY_PATH : ${prev.lib.makeLibraryPath libs}:/run/opengl-driver/lib:${prev.libva.out}/lib \
        --set LIBVA_DRIVER_NAME radeonsi \
        --set LIBVA_DRIVERS_PATH /run/opengl-driver/lib/dri \
        --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json
    '';
  });
}
