{ config, pkgs, ... }:
{
  imports = [
    ./programs/kak
    ./programs/tmux.nix
    ./programs/gitui.nix
    ./programs/broot.nix
    ./programs/shell.nix
    ./programs/rokit.nix
  ];

  home.username = "ivy";
  home.homeDirectory = "/home/ivy";

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "selectgender";
    userEmail = "sylviaviajung@gmail.com";
  };
}
