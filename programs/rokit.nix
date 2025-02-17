{ config, pkgs, ... }:
let
  rokit = pkgs.rustPlatform.buildRustPackage rec {
    pname = "rokit";
    version = "1.0.0";
    useFetchCargoVendor = true;

    src = pkgs.fetchFromGitHub {
      owner = "rojo-rbx";
      repo = "rokit";
      rev = "v${version}";
      hash = "sha256-cGsxfz3AT8W/EYk3QxVfZ8vd6zGNx1Gn6R1SWCYbVz0=";
    };

    cargoHash = "sha256-km14/9SCXUSzr4rhuhjXoUKfUBj8ULiP8XRcmp/N7Mg=";
  };
in
{
  home.packages = [
    rokit
  ];

  programs.zsh.envExtra = ''
  . "$HOME/.rokit/env"
  '';
}
