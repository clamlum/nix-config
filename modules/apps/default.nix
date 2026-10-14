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
        ./resolve.nix
        # ./openrgb.nix
        ./discord.nix
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
