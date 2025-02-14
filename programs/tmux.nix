{ config, pkgs, ... }:
let
  minimalTmuxStatus = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "minimal-tmux-status";
    version = "unstable-2024-11-3";
    rtpFilePath = "minimal.tmux";

    src = pkgs.fetchFromGitHub {
      owner = "niksingh710";
      repo = "minimal-tmux-status";
      rev = "d7188c1aeb1c7dd03230982445b7360f5e230131";
      sha256 = "JtbuSxWFR94HiUdQL9uIm2V/kwGz0gbVbqvYWmEncbc=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    prefix = "C-a";
    reverseSplit = true;

    extraConfig = ''
    set-option -sa terminal-overrides ",xterm*:Tc"

    bind -n C-h select-pane -L
    bind -n C-j select-pane -D
    bind -n C-k select-pane -U
    bind -n C-l select-pane -R

    bind j swap-pane -D
    bind k swap-pane -U

    set-option -g renumber-windows on

    bind v split-window -h -c "#{pane_current_path}"
    bind s split-window -v -c "#{pane_current_path}"

    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';

    plugins = with pkgs; [
      tmuxPlugins.yank
      minimalTmuxStatus
    ];
  };
}
