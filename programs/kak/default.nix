{ config, pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };

  ktsConfig = {
    language = {
      luau = {
        grammar = {
          path = "src";
          compile = "cc";
          compile_args = [
            "-c"
            "-fpic"
            "../scanner.c"
            "../parser.c"
            "-I"
            ".."
          ];
          compile_flags = [ "-O3" ];
          link = "cc";
          link_args = [
            "-shared"
            "-fpic"
            "scanner.o"
            "parser.o"
            "-o"
            "luau.so"
          ];
          link_flags = [ "-O3" ];

          source.git = {
            url = "https://github.com/polychromatist/tree-sitter-luau";
            pin = "40bd6e9733af062d9e60b2c879e0ba4c759c675f";
          };
        };
        queries = {
          path = "helix-queries";

          source.git = {
            url = "https://github.com/polychromatist/tree-sitter-luau";
            pin = "40bd6e9733af062d9e60b2c879e0ba4c759c675f";
          };
        };
      };
    };
  };
in
{
  home.packages = with pkgs; [
    kak-tree-sitter
  ];

  home.file.".config/kak/autoload/" = {
    source = ./autoload;
    recursive = true;
  };

  home.file.".config/kak-tree-sitter/config.toml".source =
    tomlFormat.generate "config.toml" ktsConfig;

  programs.gitui = {
    enable = true;
    keyConfig = ''
      move_left: Some(( code: Char('h'), modifiers: "")),
      move_right: Some(( code: Char('l'), modifiers: "")),
      move_up: Some(( code: Char('k'), modifiers: "")),
      move_down: Some(( code: Char('j'), modifiers: "")),
    '';
    theme = ''
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
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      default_flags = "-g";
      show_selection_mark = true;
      content_search_max_file_size = "10MB";
      enable_kitty_keyboard = false;
      lines_before_match_in_preview = 1;
      lines_after_match_in_preview = 1;

      verbs = [
        {
          name = "touch";
          invocation = "t {new_file}";
          execution = "touch {directory}/{new_file}";
          leave_broot = false;
        }
        {
          invocation = "cpa {test}";
          external = "cp -r {directory}/* {dest}";
          from_shell = true;
        }
      ];

      skin = { };
    };
  };

  programs.kakoune = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      # 80 char limit
      add-highlighter global/column-limit column 80 default,black+d

      # highlight trailing whitespace
      add-highlighter global/ regex \h+$ 0:Error

      god-mode-activate-mappings

      eval %sh{ kak-tree-sitter -dks -vvvvv --init $kak_session }

      colorscheme custom
    '';

    config = {
      alignWithTabs = true;
      autoReload = "yes";
      indentWidth = 8;
      showMatching = true;
      numberLines = {
        enable = true;
        highlightCursor = true;
        relative = true;
        separator = "\" \"";
      };

      showWhitespace = {
        enable = true;
        lineFeed = " ";
        space = " ";
      };

      ui = {
        assistant = "none";
        statusLine = "top";
      };

      hooks = [
        # jk to escape
        {
          name = "InsertChar";
          option = "k";
          commands = ''
            try %{
              exec -draft hH <a-k>jk<ret> d
              exec <esc>
            }
          '';
        }

        # tab to navigate completion window
        {
          name = "InsertCompletionShow";
          option = ".*";
          commands = ''
            try %{
              execute-keys -draft 'h<a-K>\h<ret>'

              map window insert <tab> <c-n>
              map window insert <s-tab> <c-p>

              hook -once -always window InsertCompletionHide .* %{
                unmap window insert <tab> <c-n>
                unmap window insert <s-tab> <c-p>
              }
            }
          '';
        }

        # indent on new line
        {
          name = "InsertChar";
          option = "\\n";
          commands = ''
            evaluate-commands -draft -itersel %{
              # preserve previous line indent
              try %{ execute-keys -draft <semicolon> K <a-&> }

              # cleanup trailing whitespaces from previous line
              try %{ execute-keys -draft k x s \h+$ <ret> d }
            }
          '';
        }
      ];

      keyMappings = [
        # vim reflexes
        {
          key = "<c-w>";
          mode = "insert";
          effect = "<esc>:execute-keys bd<ret>i";
          docstring = "delete word in insert mode";
        }
        {
          key = "D";
          mode = "normal";
          effect = "<a-l>d";
          docstring = "delete to end of line";
        }
        {
          key = "Y";
          mode = "normal";
          effect = "<a-l>y";
          docstring = "yank to end of line";
        }

        # some default keys given more life
        {
          key = "\"<esc>\"";
          mode = "normal";
          effect = ";,";
          docstring = "collapse all cursors";
        }
        {
          key = "\"'\"";
          mode = "normal";
          effect = "<a-;>";
          docstring = "flip cursor position";
        }

        # these will change your life
        {
          key = "q";
          mode = "normal";
          effect = "[p";
          docstring = "prev paragraph";
        }
        {
          key = "e";
          mode = "normal";
          effect = "]p";
          docstring = "next paragraph";
        }
        {
          key = "Q";
          mode = "normal";
          effect = "{p";
          docstring = "select prev paragraph";
        }
        {
          key = "E";
          mode = "normal";
          effect = "}p";
          docstring = "select next paragraph";
        }

        # simply didnt have a use for m keys lol
        {
          key = "m";
          mode = "normal";
          effect = "<c-d>";
          docstring = "next half page";
        }
        {
          key = "M";
          mode = "normal";
          effect = "<c-u>";
          docstring = "prev half page";
        }

        # some extras
        {
          key = "y";
          mode = "user";
          effect = "<a-|>clip.exe<ret>";
          docstring = "copy to system clipboard";
        }

        # defined in autoload/expand-region.kak
        {
          key = "z";
          mode = "normal";
          effect = ":expand<ret>";
          docstring = "expand region";
        }

        # defined in autoload/comment.kak
        {
          key = "c";
          mode = "user";
          effect = ":comment-line<ret>";
          docstring = "comment line";
        }

        # defined in autoload/fuzzy.kak
        {
          key = "f";
          mode = "user";
          effect = ":fuzzy-edit<ret>";
          docstring = "fuzzy find files";
        }
        {
          key = "s";
          mode = "user";
          effect = ":fuzzy-grep<ret>";
          docstring = "fuzzy find project grep";
        }
        {
          key = "b";
          mode = "user";
          effect = ":fuzzy-buffer<ret>";
          docstring = "fuzzy find buffers";
        }

        # defined in autoload/tmux.kak
        {
          key = "w";
          mode = "user";
          effect = ":enter-user-mode window<ret>";
          docstring = "enter window mode";
        }
        {
          key = "s";
          mode = "window";
          effect = ":tmux-split-vertical<ret>";
          docstring = "split vertical window";
        }
        {
          key = "v";
          mode = "window";
          effect = ":tmux-split-horizontal<ret>";
          docstring = "split horizontal window";
        }

        # defined in autoload/god-mode.kak
        {
          key = "v";
          mode = "normal";
          effect = ":enter-user-mode god-mode<ret>";
          docstring = "enter god mode";
        }

        # defined in autoload/language-mode.kak
        {
          key = "l";
          mode = "user";
          effect = ":enter-user-mode language<ret>";
          docstring = "enter language mode";
        }

        # cli tools :D
        {
          key = "t";
          mode = "user";
          effect = ":tmux-terminal-window broot<ret>";
          docstring = "open broot";
        }
        {
          key = "g";
          mode = "user";
          effect = ":tmux-terminal-window gitui<ret>";
          docstring = "open gitui";
        }
        {
          key = "r";
          mode = "user";
          effect = ":tmux-terminal-window rgr ";
          docstring = "open repgrep prompt";
        }
      ];
    };
  };

  home.file.".config/kak/colors/custom.kak".text = ''
    declare-option str base00 'rgb:${config.stylix.base16Scheme.base00}'
    declare-option str base01 'rgb:${config.stylix.base16Scheme.base01}'
    declare-option str base02 'rgb:${config.stylix.base16Scheme.base02}'
    declare-option str base03 'rgb:${config.stylix.base16Scheme.base03}'
    declare-option str base04 'rgb:${config.stylix.base16Scheme.base04}'
    declare-option str base05 'rgb:${config.stylix.base16Scheme.base05}'
    declare-option str base06 'rgb:${config.stylix.base16Scheme.base06}'
    declare-option str base07 'rgb:${config.stylix.base16Scheme.base07}'
    declare-option str base08 'rgb:${config.stylix.base16Scheme.base08}'
    declare-option str base09 'rgb:${config.stylix.base16Scheme.base09}'
    declare-option str base0A 'rgb:${config.stylix.base16Scheme.base0A}'
    declare-option str base0B 'rgb:${config.stylix.base16Scheme.base0B}'
    declare-option str base0C 'rgb:${config.stylix.base16Scheme.base0C}'
    declare-option str base0D 'rgb:${config.stylix.base16Scheme.base0D}'
    declare-option str base0E 'rgb:${config.stylix.base16Scheme.base0E}'
    declare-option str base0F 'rgb:${config.stylix.base16Scheme.base0F}'

    set-face global value "%opt{base09}"
    set-face global type "%opt{base08}"
    set-face global variable "%opt{base08}"
    set-face global module "%opt{base0D}"
    set-face global function "%opt{base0D}"
    set-face global identifier "%opt{base08}"
    set-face global string "%opt{base0B}"
    set-face global error "%opt{base08}"
    set-face global keyword "%opt{base0E}"
    set-face global operator "%opt{base05}"
    set-face global attribute "%opt{base09}"
    set-face global bracket "%opt{base05}+b"
    set-face global arguement "%opt{base09}"
    set-face global comma "%opt{base05}"
    set-face global constant "%opt{base09}+b"
    set-face global comment "%opt{base03}+i"
    set-face global documentation "%opt{base03}+i"
    set-face global docstring "%opt{base03}+i"
    set-face global docstring "%opt{base0A}"
    set-face global meta "%opt{base0C}"
    set-face global builtin "%opt{base0C}+b"

    set-face global title "%opt{base0E}"
    set-face global header "%opt{base0D}"
    set-face global bold "%opt{base0E}"
    set-face global italic "%opt{base0E}"
    set-face global mono "%opt{base0B}"
    set-face global block "%opt{base0D}"
    set-face global link "%opt{base0B}"
    set-face global bullet "%opt{base0B}"
    set-face global list "%opt{base05}"

    set-face global Default "%opt{base05},%opt{base00}"
    set-face global PrimarySelection "%opt{base00},%opt{base0A}"
    set-face global SecondarySelection "%opt{base03},%opt{base0A}"
    set-face global PrimaryCursor "%opt{base00},%opt{base05}"
    set-face global SecondaryCursor "%opt{base00},%opt{base0C}"
    set-face global PrimaryCursorEol "%opt{base00},%opt{base0A}"
    set-face global SecondaryCursorEol "%opt{base00},%opt{base0D}"
    set-face global LineNumbers "%opt{base04},%opt{base00}"
    set-face global LineNumberCursor "%opt{base0A},%opt{base00}+b"
    set-face global LineNumbersWrapped "%opt{base04},%opt{base00}+i"
    set-face global MenuForeground "%opt{base06},%opt{base01}+b"
    set-face global MenuBackground "%opt{base0D},%opt{base07}"
    set-face global MenuInfo "%opt{base0D},%opt{base07}"
    set-face global Information "%opt{base01},%opt{base07}"
    set-face global Error "%opt{base01},%opt{base08}"
    set-face global DiagnosticError "%opt{base08}"
    set-face global DiagnosticWarning "%opt{base0A}"
    set-face global StatusLine "%opt{base04},%opt{base02}"
    set-face global StatusLineMode "%opt{base0A},%opt{base02}"
    set-face global StatusLineInfo "%opt{base06},%opt{base02}"
    set-face global StatusLineValue "%opt{base04},%opt{base02}"
    set-face global StatusCursor "%opt{base02},%opt{base05}"
    set-face global Prompt "%opt{base0A},%opt{base02}"
    set-face global MatchingChar "%opt{base0D},%opt{base00}"
    set-face global Whitespace "%opt{base01},%opt{base00}+f"
    set-face global WrapMarker Whitespace
    set-face global BufferPadding "%opt{base04},%opt{base00}"
    set-face global Search "%opt{base05},%opt{base01}"

    set-face global ts_attribute                    "%opt{base0D}"
    set-face global ts_comment                      "%opt{base04}+i"
    set-face global ts_conceal                      "%opt{base0E}+i"
    set-face global ts_constant                     "%opt{base09}"
    set-face global ts_constant_builtin_boolean     "%opt{base0C}"
    set-face global ts_constant_character           "%opt{base0A}"
    set-face global ts_constant_macro               "%opt{base0E}"
    set-face global ts_constructor                  "%opt{base0D}"
    set-face global ts_diff_plus                    "%opt{base0B}"
    set-face global ts_diff_minus                   "%opt{base08}"
    set-face global ts_diff_delta                   "%opt{base0D}"
    set-face global ts_diff_delta_moved             "%opt{base0E}"
    set-face global ts_error                        "%opt{base08}+b"
    set-face global ts_function                     "%opt{base0D}"
    set-face global ts_function_builtin             "%opt{base0D}+i"
    set-face global ts_function_macro               "%opt{base0E}"
    set-face global ts_hint                         "%opt{base0D}+b"
    set-face global ts_info                         "%opt{base0B}+b"
    set-face global ts_keyword                      "%opt{base0E}"
    set-face global ts_keyword_conditional          "%opt{base0E}+i"
    set-face global ts_keyword_control_conditional  "%opt{base0E}+i"
    set-face global ts_keyword_control_directive    "%opt{base0E}+i"
    set-face global ts_keyword_control_import       "%opt{base0E}+i"
    set-face global ts_keyword_directive            "%opt{base0E}+i"
    set-face global ts_label                        "%opt{base0E}+i"
    set-face global ts_markup_bold                  "%opt{base09}+b"
    set-face global ts_markup_heading               "%opt{base08}"
    set-face global ts_markup_heading_1             "%opt{base08}"
    set-face global ts_markup_heading_2             "%opt{base0E}"
    set-face global ts_markup_heading_3             "%opt{base0B}"
    set-face global ts_markup_heading_4             "%opt{base0A}"
    set-face global ts_markup_heading_5             "%opt{base07}"
    set-face global ts_markup_heading_6             "%opt{base0C}"
    set-face global ts_markup_heading_marker        "%opt{base09}+b"
    set-face global ts_markup_italic                "%opt{base07}+i"
    set-face global ts_markup_list_checked          "%opt{base0B}"
    set-face global ts_markup_list_numbered         "%opt{base0D}+i"
    set-face global ts_markup_list_unchecked        "%opt{base0C}"
    set-face global ts_markup_list_unnumbered       "%opt{base0E}"
    set-face global ts_markup_link_label            "%opt{base0D}"
    set-face global ts_markup_link_url              "%opt{base0C}+u"
    set-face global ts_markup_link_uri              "%opt{base0C}+u"
    set-face global ts_markup_link_text             "%opt{base0D}"
    set-face global ts_markup_quote                 "%opt{base04}"
    set-face global ts_markup_raw                   "%opt{base0B}"
    set-face global ts_markup_strikethrough         "%opt{base04}+s"
    set-face global ts_namespace                    "%opt{base0D}+i"
    set-face global ts_operator                     "%opt{base0C}"
    set-face global ts_property                     "%opt{base0C}"
    set-face global ts_punctuation                  "%opt{base04}"
    set-face global ts_punctuation_special          "%opt{base0C}"
    set-face global ts_special                      "%opt{base0D}"
    set-face global ts_spell                        "%opt{base0E}"
    set-face global ts_string                       "%opt{base0B}"
    set-face global ts_string_regex                 "%opt{base09}"
    set-face global ts_string_regexp                "%opt{base09}"
    set-face global ts_string_escape                "%opt{base0E}"
    set-face global ts_string_special               "%opt{base0D}"
    set-face global ts_string_special_path          "%opt{base0B}"
    set-face global ts_string_special_symbol        "%opt{base0E}"
    set-face global ts_string_symbol                "%opt{base08}"
    set-face global ts_tag                          "%opt{base0E}"
    set-face global ts_tag_error                    "%opt{base08}"
    set-face global ts_text                         "%opt{base05}"
    set-face global ts_text_title                   "%opt{base0E}"
    set-face global ts_type                         "%opt{base0A}"
    set-face global ts_type_enum_variant            "%opt{base03}"
    set-face global ts_variable                     "%opt{base05}"
    set-face global ts_variable_builtin             "%opt{base08}"
    set-face global ts_variable_other_member        "%opt{base0C}"
    set-face global ts_variable_parameter           "%opt{base0F}+i"
    set-face global ts_warning                      "%opt{base09}+b"
  '';
}
