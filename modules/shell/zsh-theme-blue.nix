{
  flake.wrappers.zsh = {
    constructFiles.themeBlue = {
      relPath = "themes/custom.zsh-theme";
      content = ''
        PROMPT="%F{#4EA1FF}%n@%f"
        PROMPT+="%F{#6C8AFF}%m%f "
        PROMPT+="%F{#B4D7FF}%4~%f "
        PROMPT+="%(?:%F{#4EA1FF}%1{➜%} :%F{#E06C75}%1{➜%} )%{$reset_color%}"

        RPROMPT='$(git_prompt_info)'

        ZSH_THEME_GIT_PROMPT_PREFIX="%F{#4EA1FF}git:(%F{#B4D7FF}"
        ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
        ZSH_THEME_GIT_PROMPT_DIRTY="%F{#4EA1FF}) %F{#FFB86B}%1{✗%}%f"
        ZSH_THEME_GIT_PROMPT_CLEAN="%F{#4EA1FF})%f"
      '';
    };
  };
}
