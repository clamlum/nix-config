{
  flake.modules.generic.nix-shell = {
    wrappers.zsh.zshrc.content = ''
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
}
