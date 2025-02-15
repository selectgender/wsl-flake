{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    repgrep
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
          sha256 = "EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
        };
      }
    ];
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;

          segments = [
            {
              type = "path";
              style = "plain";
              background = "transparent";
              foreground = "#${config.stylix.base16Scheme.base0B}";
              template = "{{ .Path }}";
              properties.style = "full";
            }

            {
              type = "git";
              style = "plain";
              foreground = "#${config.stylix.base16Scheme.base04}";
              background = "transparent";
              template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
            }
          ];
        }

        {
          type = "rprompt";
          overflow = "hidden";

          segments = [
            {
              type = "executiontime";
              style = "plain";
              foreground = "#${config.stylix.base16Scheme.base0A}";
              background = "transparent";
              template = "{{ .FormattedMs }}";
              properties.threshold = 5000;
            }
          ];
        }

        {
          type = "prompt";
          alignment = "left";
          newline = true;

          segments = [
            {
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}#${config.stylix.base16Scheme.base08}{{end}}"
                "{{if eq .Code 0}}#${config.stylix.base16Scheme.base0E}{{end}}"
              ];
              background = "transparent";
              template = "❯ ";
            }
          ];
        }
      ];

      transient_prompt = {
        foreground_templates = [
          "{{if gt .Code 0}}#${config.stylix.base16Scheme.base08}{{end}}"
          "{{if eq .Code 0}}#${config.stylix.base16Scheme.base0E}{{end}}"
        ];
        background = "transparent";
        template = "❯ ";
      };

      secondary_prompt = {
        foreground = "#${config.stylix.base16Scheme.base0E}";
        background = "transparent";
        template = "❯❯ ";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd"
      "cd"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fd.enable = true;
  programs.ripgrep.enable = true;
}
