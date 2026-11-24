{
  flake.modules.nixos.android =
    { pkgs, ... }:
    {
      users.users.clamt.extraGroups = [ "adbusers" ];

      environment.systemPackages = with pkgs; [
        android-tools
        jdk17
        android-studio
      ];
    };
}
