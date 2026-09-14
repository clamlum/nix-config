{ pkgs, self, ... }:

let
  calculator-script = "${self.outPath}/scripts/fuzzel/fuzzel-calc.sh";
  edit-script = "${self.outPath}/scripts/fuzzel/fuzzel-edit.sh";
in

{
  home.packages = [
    pkgs.fuzzel
    pkgs.bc
  ];

  xdg.enable = true;
  xdg.desktopEntries.calc = {
    name = "=";
    comment = "Fuzzel Calculator";
    exec = "sh ${calculator-script}";
    terminal = false;
    categories = [ "Utility" ];
  };

  xdg.desktopEntries.edit = {
    name = "/";
    comment = "Fuzzel Editor";
    exec = "sh ${edit-script}";
    terminal = false;
    categories = [ "Utility" ];
  };

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        dpi-aware = "yes";
        prompt = "❯ ";
        placeholder = "Type to search…";
        show-actions = "no";
        match-mode = "fuzzy";
        terminal = "ghostty";
        exit-on-keyboard-focus-loss = "yes";

        width = 50;
        lines = 6;
        line-height = 24;
        horizontal-pad = 1;
        vertical-pad = 1;
        inner-pad = 2;
        anchor = "center";

        password-character = "*";
        filter-desktop = "yes";

        icon-theme = "Adwaita";
        icons-enabled = "no";

        sort-result = "yes";
        match-counter = "yes";

        render-workers = 2;

      };

      colors = {
        background = "1f2134ff";
        text = "c8c8e6ff";
        input = "c8c8e6ff";

        prompt = "4ea1ffff";
        match = "4ea1ffff";

        placeholder = "595959ff";
        selection = "44475aff";
        selection-text = "c8c8e6ff";
        selection-match = "4ea1ffff";

        border = "6c8affff";
        counter = "b4d7ffff";
      };

      border = {
        width = 2;
        radius = 0;
      };

      dmenu = {
        mode = "text";
        exit-immediately-if-empty = "no";
      };

      key-bindings = {
        execute = "Return Tab";
        execute-or-next = "none";
      };
    };
  };
}
