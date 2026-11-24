{ config, ... }:
let
  topConfig = config;
in
{
  flake.wrappers.zsh =
    {
      config,
      pkgs,
      wlib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.zsh ];

      hmSessionVariables = null;

      env = {
        ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };

      runtimePkgs = [
        pkgs.lsd
        pkgs.bat
        pkgs.zoxide
        pkgs.file
        pkgs.nh
        pkgs.tmux
      ];

      zshrc.content = ''
        export ZSH_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
        export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-''${HOST}-''${ZSH_VERSION}"

        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

        plugins=(git)
        source $ZSH/oh-my-zsh.sh

        alias ls="lsd --group-directories-first -A"
        alias cat="bat -p"
        alias cd="z"
        alias zed="zeditor"

        REBUILD_SCRIPT="~/nix-config/scripts/rebuild.sh"

        alias nrs="sh $REBUILD_SCRIPT -a switch"
        alias nrt="sh $REBUILD_SCRIPT -a test"
        alias nrbu="sh $REBUILD_SCRIPT -a build"
        alias nrbo="sh $REBUILD_SCRIPT -a boot"
        alias ncg="nh clean all -q"

        i () {
          if [[ $# -eq 0 ]]; then
            nix-shell
          else
            nix-shell -p "$@"
          fi
        }

        function sshkey() {
            if [[ -n $SSH_CONNECTION ]]; then
                echo "Not running copy command over SSH."
                cat ~/.ssh/id_ed25519.pub
            else
                cat ~/.ssh/id_ed25519.pub | wl-copy
                echo "Public key copied to clipboard."
            fi
        }

        function reencode() {
            local input="$1"
            local output="''${input:r}.mp4"

            ffmpeg -i "$input" \
                -vf scale=1920:1080 \
                -c:v libsvtav1 -crf 28 -preset 6 \
                -c:a aac -b:a 128k \
                "$output"
        }

        eval "$(zoxide init zsh)"

        if [[ -n "$IN_NIX_SHELL" || "''${PATH%%:*}" == /nix/store/* ]]; then
          source ${config.constructFiles.themeNixShell.path}
        else
          source ${config.constructFiles.themeBlue.path}
          cd ~
        fi
      '';
    };

  flake.modules.generic.zsh =
    {
      config,
      lib,
      pkgs,
      _class,
      ...
    }:
    {
      imports = [
        topConfig.flake.wrappers.zsh.install
      ];

      wrappers.zsh = {
        enable = true;
      }
      // lib.optionalAttrs (_class == "nixos") {
        asSystemDefault = true;
      };

      environment.systemPackages = [
        pkgs.lsd
        pkgs.bat
        pkgs.zoxide
        pkgs.file
        pkgs.nh
        pkgs.tmux
      ];
    }
    // lib.optionalAttrs (_class == "nixos") {
      programs.zsh = {
        package = config.wrappers.zsh.wrapper;
        enableGlobalCompInit = false;
      };
    };
}
