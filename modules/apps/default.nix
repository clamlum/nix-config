{ device, username, ... }:
{
  imports = [
    ./zed.nix
    ./kopuz.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./android.nix
        ./gaming.nix
        ./obs.nix
        ./discord.nix
        ./openmouse.nix
      ]
    else
      [ ]
  );

  home-manager.users.${username}.imports =
    [ ]
    ++ (
      if device != "macbook" then
        [
          ./fuzzel.nix
          ./micro.nix

          ./bars/quickshell.nix
        ]
      else
        [ ]
    );
}
