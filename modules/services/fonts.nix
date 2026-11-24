{ config, ... }:
{
  flake.modules.generic.fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        nerd-fonts.noto
        nerd-fonts.dejavu-sans-mono
        nerd-fonts.jetbrains-mono
      ];
    };

  flake.modules.nixos.fonts = {
    imports = [ config.flake.modules.generic.fonts ];

    fonts = {
      enableDefaultPackages = true;

      fontconfig = {
        enable = true;

        defaultFonts = {
          sansSerif = [
            "Noto Sans CJK SC"
            "Noto Sans"
          ];

          serif = [
            "Noto Serif CJK SC"
            "Noto Serif"
          ];

          monospace = [
            "Noto Sans Mono"
          ];

          emoji = [
            "Noto Color Emoji"
          ];
        };
      };
    };
  };
}
