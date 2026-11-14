{ stdenvNoCC, fetchurl, msitools, lib }:

stdenvNoCC.mkDerivation {
  pname = "surface-laptop-7-firmware";
  version = "26100.25.013.35106.0";

  src = fetchurl {
    url = "https://download.microsoft.com/download/b7ca2c3f-d320-4795-be0f-529a0117abb4/SurfaceLaptop7_ARM_Win11_26100_26.053.36539.0.msi";
    hash = "sha256-ZrbhrOfl8BvFks1MmueKowu7DgSrV0kc0D7CqqbhIps=";
  };

  nativeBuildInputs = [ msitools ];
  dontUnpack = true;

  fwFiles = [
    "adsp_dtbs.elf" "adspr.jsn" "adsps.jsn" "adspua.jsn" "battmgr.jsn"
    "cdsp_dtbs.elf" "cdspr.jsn" "qcadsp8380.mbn" "qccdsp8380.mbn" "qcdxkmsuc8380.mbn"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir extracted
    msiextract -C extracted "$src"
    search_path="extracted/SurfaceUpdate"
    mkdir -p out/qcom/x1e80100/microsoft
    for f in $fwFiles; do
      fw_path=$(find "$search_path" -type f -name "$f" -print -quit)
      [[ -n "$fw_path" ]] && cp -v "$fw_path" "out/qcom/x1e80100/microsoft/"
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/firmware
    cp -r out/qcom $out/lib/firmware/
    runHook postInstall
  '';

  meta.license = lib.licenses.unfree;
}
