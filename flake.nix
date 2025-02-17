{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      stylix,
      treefmt-nix,
      home-manager,
      nix-ld,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;

        settings.excludes = [
          "*.jpg"
          "*.kak"
          "*.lock"
        ];
      };

      colorschemes = import ./assets/colorschemes.nix;
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      nixosConfigurations = {
        ivy = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";

              programs.zsh.enable = true;
              users.users.ivy.shell = pkgs.zsh;

              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

              wsl.enable = true;
              wsl.defaultUser = "ivy";
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ivy = import ./home.nix;
            }
            stylix.nixosModules.stylix
            {
              stylix.enable = true;
              stylix.image = ./assets/wallpaper.jpg;
              stylix.polarity = "dark";
              stylix.base16Scheme = colorschemes.catppuccin-mocha;
            }
            nix-ld.nixosModules.nix-ld
            { programs.nix-ld.dev.enable = true; }
          ];
        };
      };
    };
}
