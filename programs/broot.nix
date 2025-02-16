{ config, pkgs, ... }: {
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # the imports in the default file override any skin changes you make >:(

  # home manager settings are lackluster :(
  home.file.".config/broot/conf.hjson".text = ''
  default_flags: -g
  show_selection_mark: true
  content_search_max_file_size: 10MB
  enable_kitty_keyboard: false
  lines_before_match_in_preview: 1
  lines_after_match_in_preview: 1

  verbs: [
    {
      name: touch
      invocation: t {new_file}
      execution: "touch {directory}/{new_file}"
      leave_broot: false
    }
    {
      invocation: "cpa {dest}"
      external: "cp -r {directory}/* {dest}"
      from_shell: true
    }
  ]

  skin: {
    default: white none
    input: white none
  }
  '';
}
