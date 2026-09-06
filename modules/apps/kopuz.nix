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
  environment.systemPackages = [
    inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${username}.home.file.".config/kopuz/settings.toml" = {
    text = configFile;
    force = true;
  };
}
