{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.protonup-qt
        pkgs.prismlauncher
        pkgs.jdk25
        pkgs.mangohud
        pkgs.wineWow64Packages.stable
        pkgs.winetricks
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        protontricks.enable = true;
      };

      programs.gamescope = {
        enable = true;
        enableWsi = true;
        capSysNice = false;
      };

      programs.firejail.enable = true;
    };
}
