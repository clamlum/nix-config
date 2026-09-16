{ pkgs, ... }:

{
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  networking.networkmanager.enable = true;

  security.pki.certificateFiles = [ ../resources/certs/ca.crt ];

  services.openssh.enable = true;
  programs.ssh.extraConfig = ''
    Host pc
      HostName 192.168.2.1

    Host laptop
      HostName 192.168.2.2

    Host media
      HostName 192.168.2.10
      User root

    Host host
      HostName 192.168.2.20
      User root
  '';
  programs.ssh.knownHosts = {
    pc = {
      hostNames = [
        "pc"
        "192.168.2.1"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFpRxt/w44Zun2tL6DjOyVI7eVV4ISDHEy0dbMCbTGC";
    };
    laptop = {
      hostNames = [
        "laptop"
        "192.168.2.2"
      ];
      publicKey = "192.168.2.2 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3LuO3HPPmYPk9nvgyfXf+rgg7AJCNJSQBcHzpzHA2w";
    };
    media = {
      hostNames = [
        "media"
        "192.168.2.10"
      ];
      publicKey = "192.168.2.10 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPZiyCRx8WjX1Fmq63abOBVRYWC6ObrgYh0HxxtPUuM7";
    };
    host = {
      hostNames = [
        "host"
        "192.168.2.20"
      ];
      publicKey = "192.168.2.20 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBanTj2B8RyDqcbh5q4V7jVf2cOZkfBg0YWiO5MJhGCV";
    };
  };

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  programs.zsh.enable = true;

  users.users.clamt = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH/sXIx+I7BCq6T4QfiEWqvh+E1d9+y4CrTijURf5Wsq clamt"
    ];
    shell = pkgs.zsh;
  };

  programs.nix-ld.enable = true;

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
}
