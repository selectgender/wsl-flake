{ config, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };

  conf = {
    default_flags = "-g";
    show_selection_mark = true;
    content_search_max_file_size = "10MB";
    enable_kitty_keyboard = false;
    lines_before_match_in_preview = 1;
    lines_after_match_in_preview = 1;

    imports = [
      "verbs.toml"

      {
        luma = "unknown";
        file = "skins/custom.toml";
      }
    ];
  };

  verbs = [
    {
      name = "touch";
      invocation = "t {new_file}";
      execution = "touch {directory}/{new_file}";
      leave_broot = false;
    }
    {
      invocation = "cpa {dest}";
      external = "cp -r {directory}/* {dest}";
      from_shell = true;
    }
  ];

  skin = with config.lib.stylix.colors; {
    # defaults
    input = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";
    selected_line = "none rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b})";
    default = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";
    tree = "rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b}) none";
    parent = "rgb(${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}) none";
    file = "none none";

    # permissions
    perm__ = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";
    perm_r = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    perm_w = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
    perm_x = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) none";
    owner = "rgb(${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}) none";
    group = "rgb(${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}) none";

    # date
    dates = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";

    # directory
    directory = "rgb(${base07-rgb-r}, ${base07-rgb-g}, ${base07-rgb-b}) none Bold";
    exe = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) none";
    link = "rgb(${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}) none";
    pruning = "rgb(${base02-rgb-r}, ${base02-rgb-g}, ${base02-rgb-b}) none Italic";

    # preview
    preview_title = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";
    preview = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";
    preview_line_number = "rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b}) none";
    preview_separator = "rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b}) none";

    # match
    char_match = "rgb(${base06-rgb-r}, ${base06-rgb-g}, ${base06-rgb-b}) rgb(${base03-rgb-r}, ${base03-rgb-g}, ${base03-rgb-b}) Bold Italic";
    content_match = "rgb(${base06-rgb-r}, ${base06-rgb-g}, ${base06-rgb-b}) rgb(${base03-rgb-r}, ${base03-rgb-g}, ${base03-rgb-b}) Bold Italic";
    preview_match = "rgb(${base06-rgb-r}, ${base06-rgb-g}, ${base06-rgb-b}) rgb(${base03-rgb-r}, ${base03-rgb-g}, ${base03-rgb-b}) Bold Italic";

    count = "rgb(${base06-rgb-r}, ${base06-rgb-g}, ${base06-rgb-b}) none";
    sparse = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
    content_extract = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none Italic";

    # git
    git_branch = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_insertions = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_deletions = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_status_current = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_status_modified = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_status_new = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none Bold";
    git_status_ignored = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_status_conflicted = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    git_status_other = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    staging_area_title = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";

    # flag
    flag_label = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
    flag_value = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none Bold";

    # status
    status_normal = "none rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";
    status_italic = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b}) Italic";
    status_bold = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b}) Bold";
    status_ellipsis = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b}) Bold";
    status_error = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b})";
    status_job = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";
    status_code = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";
    mode_command_mark = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) rgb(${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b})";

    # help
    help_paragraph = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";
    help_headers = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none Bold";
    help_bold = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none Bold";
    help_italic = "rgb(${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}) none Italic";
    help_code = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) rgb(${base02-rgb-r}, ${base02-rgb-g}, ${base02-rgb-b})";
    help_table_border = "rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b}) none";

    # hex
    hex_null = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";
    hex_ascii_graphic = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    hex_ascii_whitespace = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) none";
    hex_ascii_other = "rgb(${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}) none";
    hex_non_ascii = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
    file_error = "rgb(${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}) none";

    # purpose
    purpose_normal = "none none";
    purpose_italic = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none Italic";
    purpose_bold = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none Bold";
    purpose_ellipsis = "none none";

    # scrollbar
    scrollbar_track = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) none";
    scrollbar_thumb = "rgb(${base04-rgb-r}, ${base04-rgb-g}, ${base04-rgb-b}) none";

    # good to bad
    good_to_bad_0 = "rgb(${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}) none";
    good_to_bad_1 = "rgb(${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}) none";
    good_to_bad_2 = "rgb(${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}) none";
    good_to_bad_3 = "rgb(${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}) none";
    good_to_bad_4 = "rgb(${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}) none";
    good_to_bad_5 = "rgb(${base07-rgb-r}, ${base07-rgb-g}, ${base07-rgb-b}) none";
    good_to_bad_6 = "rgb(${base0E-rgb-r}, ${base0E-rgb-g}, ${base0E-rgb-b}) none";
    good_to_bad_7 = "rgb(${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}) none";
    good_to_bad_8 = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
    good_to_bad_9 = "rgb(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}) none";
  };
in
{
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  # the imports in the default file override any skin changes you make >:(
  home.file.".config/broot/conf.toml".source = tomlFormat.generate "conf.toml" conf;

  home.file.".config/broot/verbs.toml".source = tomlFormat.generate "verbs.toml" {
    inherit verbs;
  };

  home.file.".config/broot/skins/custom.toml".source = tomlFormat.generate "custom.toml" {
    inherit skin;
  };
}
