{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = [
      pkgs.libva-vdpau-driver
      pkgs.libvdpau-va-gl
    ];
  };

  environment.systemPackages = [
    pkgs.nvtopPackages.amd
    pkgs.btop-rocm
  ];

  services.lact.enable = true;

  hardware.amdgpu.overdrive.enable = true;

  hardware.amdgpu.overdrive.ppfeaturemask = "0xffffffff";
}
