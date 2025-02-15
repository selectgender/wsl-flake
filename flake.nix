{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      stylix,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
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
              stylix.base16Scheme = {
                base00 = "1e1e2e";
                base01 = "181825";
                base02 = "313244";
                base03 = "45475a";
                base04 = "585b70";
                base05 = "cdd6f4";
                base06 = "f5e0dc";
                base07 = "b4befe";
                base08 = "f38ba8";
                base09 = "fab387";
                base0A = "f9e2af";
                base0B = "a6e3a1";
                base0C = "94e2d5";
                base0D = "89b4fa";
                base0E = "cba6f7";
                base0F = "f2cdcd";
              };
            }
          ];
        };
      };
    };
}
