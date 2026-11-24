{
  flake.modules.nixos.configuration =
    { config, ... }:
    {
      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];

      networking.networkmanager.enable = true;

      services.openssh.enable = true;

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
      };

      programs.nix-ld.enable = true;

      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      environment.sessionVariables.NH_OS_FLAKE = config.vars.configPath;
    };
}
