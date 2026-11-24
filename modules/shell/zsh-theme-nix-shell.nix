{
  flake.wrappers.zsh = {
    constructFiles.themeNixShell = {
      relPath = "themes/nix-shell.zsh-theme";
      content = ''
        PROMPT="%F{#77b6e1}%n@%f"
        PROMPT+="%F{#4d6fb7}%m%f "
        PROMPT+="%F{#77b6e1}%4~%f "
        PROMPT+="%F{#77b6e1}󱄅 "
        PROMPT+="%(?:%{$fg[green]%}%1{➜%} :%{$fg[red]%}%1{➜%} )%{$reset_color%}"

        RPROMPT='$(git_prompt_info)'

        ZSH_THEME_GIT_PROMPT_PREFIX="%F{#77b6e1}git:(%F{#FFF59D}"
        ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
        ZSH_THEME_GIT_PROMPT_DIRTY="%F{#77b6e1}) %F{#FFB86B}%1{✗%}%f"
        ZSH_THEME_GIT_PROMPT_CLEAN="%F{#77b6e1})%f"
      '';
    };
  };
}
