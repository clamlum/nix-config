{
  flake.modules.nixos.discord =
    { pkgs, ... }:
    let
      vencord = pkgs.vencord.overrideAttrs (
        final: prev:
        let
          src = pkgs.fetchFromGitHub {
            owner = "Vendicated";
            repo = "Vencord";
            rev = "main";
            hash = "sha256-L+E/SPVbl/+K6bwC11tkWUYdkKZ8b3K+Dtp6TidLBuw=";
          };
        in
        {
          version = src.rev;
          inherit src;

          pnpmDeps = pkgs.fetchPnpmDeps {
            pname = prev.pname;
            inherit src;
            pnpm = pkgs.pnpm_12;
            fetcherVersion = 5;
            hash = "sha256-/cnY+wj2/oHohUwf7zUHsE4aWI8YdhBNO8jSVuvQH+M=";
          };
        }
      );

      discord = pkgs.discord.override {
        inherit vencord;
        withVencord = true;
        withOpenASAR = true;
      };

      discord-wrapped = pkgs.symlinkJoin {
        name = "discord-wrapped";
        paths = [ discord ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/discord --add-flags "--enable-blink-features=MiddleClickAutoscroll"
          wrapProgram $out/bin/Discord --add-flags "--enable-blink-features=MiddleClickAutoscroll"
        '';
      };
    in
    {
      environment.systemPackages = [
        discord-wrapped
      ];
    };
}
