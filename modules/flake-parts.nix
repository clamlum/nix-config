{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.flake.meta = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = "Shared metadata across the flake (e.g. username).";
  };

  config = {
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    flake.meta.username = "clamt";
  };
}
