{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon-support = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    asahi-firmware = {
      url = "path:/etc/nixos-firmware";
      flake = false;
    };

    not-quite-tiny-dfr.url = "git+ssh://git@github.com/clamlum/not-quite-tiny-dfr.git";

    kopuz = {
      url = "github:kopuz-org/kopuz";
    };

    helium = {
      url = "github:clamlum/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango/wl-only";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree ./modules
    );

  nixConfig = {
    experimentalFeatures = [
      "nix-command"
      "flakes"
      "pipe-operators"
      "auto-optimise-store"
    ];
  };
}
