{
  pkgs,
  inputs,
  username,
  ...
}:
let
  configFile = ''
    discord_presence = false
    settings_layout = "TopBar"
    theme = "ayu-mirage"
    ui_style = "Vaxry"
  '';
in
{
  nix.settings = {
    substituters      = ["https://kopuz.cachix.org" ];
    trusted-public-keys = ["kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="];
  };

  environment.systemPackages = [
    inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${username}.home.file.".config/kopuz/settings.toml" = {
    text = configFile;
    force = true;
  };
}
