{ config, ... }:
let
  inherit (config.flake.meta) username;
in
{
  flake.modules.homeManager.nix-shell = {
    home.file.".zshrc".text = ''
      f () {
        local -a COMMAND=(nix shell)
        local -a args=()
        local impure=0

        for arg in "$@"; do
          if [[ "$arg" == "-i" ]]; then
            impure=1
          else
            args+=("$arg")
          fi
        done

        if (( impure )); then
          export NIXPKGS_ALLOW_UNFREE=1
          COMMAND=(nix shell --impure)
        fi

        if [[ ''${#args[@]} -eq 0 ]]; then
          if [[ -f flake.nix ]]; then
            nix develop
          else
            nix-shell
          fi
        else
          "''${COMMAND[@]}" "''${args[@]/#/nixpkgs#}"
        fi
      }
    '';
  };

  flake.modules.generic.nix-shell = {
    home-manager.users.${username}.imports = [
      config.flake.modules.homeManager.nix-shell
    ];
  };
}
