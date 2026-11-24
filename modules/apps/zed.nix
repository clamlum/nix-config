{
  flake.modules.generic.zed =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.zed-editor
        pkgs.nil
        pkgs.nixd
        pkgs.kdePackages.qtdeclarative
        pkgs.color-lsp
      ];
    };
}
