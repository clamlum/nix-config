{ pkgs, nixpkgs-stable, ... }:

let
  stable = import nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in

{
  environment.systemPackages = [
    stable.lutris
    pkgs.protonup-qt
    pkgs.prismlauncher
    pkgs.jdk25
    pkgs.mangohud
    # pkgs.steamtinkerlaunch
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
}
