{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    kopuz.url = "github:kopuz-org/kopuz";
    helium.url = "github:clamlum/helium-flake";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      mkSystem = nixpkgs.lib.nixosSystem;
      username = "clamt";
    in
    {
      nixosConfigurations = {
        nixos =
          let
            device = "nixos";
          in
          mkSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit device username;
              inherit (inputs) nixpkgs-stable self;
              inherit inputs;
            };
            modules = [
              ./modules
              ./modules/devices/pc
              ./modules/apps
              ./modules/shell
              ./modules/desktops/niri
              ./modules/desktops/kde
              ./modules/services
              ./modules/desktops/dm
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit device username self;
                  };
                };
              }
            ];
          };

        asahi =
          let
            device = "asahi";
          in
          mkSystem {
            system = "aarch64-linux";
            specialArgs = {
              device = device;
              inherit username;
              inherit (inputs) nixpkgs-stable self;
              inherit inputs;
            };
            modules = [
              ./modules
              ./modules/devices/asahi
              ./modules/apps
              ./modules/shell
              ./modules/desktops/niri
              ./modules/services
              ./modules/desktops/dm
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit device username self;
                  };
                };
              }
            ];
          };

        wsl =
          let
            device = "wsl";
          in
          mkSystem {
            system = "aarch64-linux";
            specialArgs = {
              device = device;
              inherit username;
              inherit (inputs) self;
              inherit inputs;
            };
            modules = [
              ./modules

              ./modules/devices/wsl

              ./modules/shell
              ./modules/services
              inputs.nixos-wsl.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
            ];
          };

        laptop =
          let
            device = "laptop";
          in
          mkSystem {
            system = "x86_64-linux";
            specialArgs = {
              device = device;
              inherit username;
              inherit (inputs) nixpkgs-stable self;
              inherit inputs;
            };
            modules = [
              ./modules
              ./modules/devices/laptop
              ./modules/apps
              ./modules/shell
              ./modules/desktops/niri
              ./modules/services
              ./modules/desktops/dm
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = {
                  inherit device username self;
                };
              }
            ];
          };
      };

      darwinConfigurations.macbook =
        let
          device = "macbook";
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit device;
            inherit username;
            inherit (inputs) nixpkgs-stable self;
            inherit inputs;
          };
          modules = [
            ./modules
            ./modules/devices/macbook
            ./modules/apps
            ./modules/shell
            ./modules/services/fonts.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit device username self;
                };
              };
            }
          ];
        };
    };

  nixConfig = {
    experimentalFeatures = [
      "nix-command"
      "flakes"
      "pipe-operators"
      "auto-optimise-store"
    ];
  };
}
