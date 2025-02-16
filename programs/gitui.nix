{ config, pkgs, ... }:
{
  # programs.gitui is fucking stupid
  # absolutely idiotic
  # literally have to take matters into your own hands for ANYTHING to work
  # decently... fuck this shit
  # the theme option literally just appends to the default settings,,
  # and the default settings get priority anyways >:(

  home.packages = with pkgs; [
    gitui
  ];

  home.file.".config/gitui/key_bindings.ron".text = ''
    move_left: Some(( code: Char('h'), modifiers: "")),
    move_right: Some(( code: Char('l'), modifiers: "")),
    move_up: Some(( code: Char('k'), modifiers: "")),
    move_down: Some(( code: Char('j'), modifiers: "")),
  '';

  # not using withHashtags bc apparently it messes up the colors :(
  home.file.".config/gitui/theme.ron".text = ''
    (
      selected_tab: Some("Reset"),
      command_fg: Some("#${config.stylix.base16Scheme.base05}"),
      selection_bg: Some("#${config.stylix.base16Scheme.base04}"),
      selection_fg: Some("#${config.stylix.base16Scheme.base05}"),
      cmdbar_bg: Some("#${config.stylix.base16Scheme.base01}"),
      cmdbar_extra_lines_bg: Some("#${config.stylix.base16Scheme.base01}"),
      disabled_fg: Some("#${config.stylix.base16Scheme.base04}"),
      diff_line_add: Some("#${config.stylix.base16Scheme.base0B}"),
      diff_line_delete: Some("#${config.stylix.base16Scheme.base08}"),
      diff_file_added: Some("#${config.stylix.base16Scheme.base0B}"),
      diff_file_removed: Some("#${config.stylix.base16Scheme.base08}"),
      diff_file_moved: Some("#${config.stylix.base16Scheme.base0E}"),
      diff_file_modified: Some("#${config.stylix.base16Scheme.base09}"),
      commit_hash: Some("#${config.stylix.base16Scheme.base07}"),
      commit_time: Some("#${config.stylix.base16Scheme.base04}"),
      commit_author: Some("#${config.stylix.base16Scheme.base0D}"),
      danger_fg: Some("#${config.stylix.base16Scheme.base08}"),
      push_gauge_bg: Some("#${config.stylix.base16Scheme.base0D}"),
      push_gauge_fg: Some("#${config.stylix.base16Scheme.base00}"),
      tag_fg: Some("#${config.stylix.base16Scheme.base06}"),
      branch_fg: Some("#${config.stylix.base16Scheme.base0C}")
    )
  '';
}
