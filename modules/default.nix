{ device, username, ... }:

{
  imports =
    [ ]
    ++ (
      if device != "macbook" then
        [
          ./configuration.nix
          ./pkgs.nix
          ./variables.nix
        ]
      else if device == "macbook" then
        [
          ./pkgs.nix
        ]
      else
        [ ]
    );

  home-manager.users.${username}.imports =
    [ ] ++ (if device != "macbook" then [ ./home.nix ] else [ ]);

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
