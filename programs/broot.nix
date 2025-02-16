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

  skin = {
    default = "white none";
    input = "white none";
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
