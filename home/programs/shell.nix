{ pkgs, lib, configName, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$kubernetes"
        "$terraform"
        "$golang"
        "$python"
        "$nodejs"
        "$docker_context"
        "$azure"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        truncation_length = 3;
        truncation_symbol = ".../";
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context( \\($namespace\\))]($style) ";
        symbol = "K8s ";
      };

      terraform = {
        disabled = false;
        format = "[$symbol$workspace]($style) ";
      };

      git_branch = {
        symbol = " ";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Atuin (shell history)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      inline_height = 20;
    };
  };

  # Direnv with nix-direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # Modern replacements
      ls = "eza --icons";
      ll = "eza -lah --icons";
      la = "eza -a --icons";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
      du = "dust";

      # Git
      gs = "git status";
      gst = "git status";
      gd = "git diff";
      gds = "git diff --staged";
      gl = "git log --oneline --graph";
      ga = "git add";
      gaa = "git add --all";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gp = "git push";
      gpl = "git pull";
      gco = "git checkout";
      gcb = "git checkout -b";
      gss = "git stash";
      gsp = "git stash pop";
      grb = "git rebase";

      # Kubernetes
      k = "kubectl";
      kx = "kubectx";
      kn = "kubens";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";

      # Nix
      rebuild = "sudo darwin-rebuild switch --flake ~/dev/workstation-setup#${configName}";

      # Python
      python = "python3";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      LANG = "en_US.UTF-8";
    };

    # Zinit setup (early init) + plugin loading
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Zinit installation directory
        ZINIT_HOME="${pkgs.zinit}/share/zinit"
      '')
      ''
        # Source Zinit
        source "''${ZINIT_HOME}/zinit.zsh"

        # Zinit plugins (completions and fzf-tab only)
        zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
        zinit light zsh-users/zsh-completions

        zinit ice wait lucid
        zinit light Aloxaf/fzf-tab

        # fzf-tab configuration
        zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        # Better completion settings
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu select

        # uv completions
        if command -v uv &> /dev/null; then
          eval "$(uv generate-shell-completion zsh)"
        fi
      ''
    ];
  };

  # Zinit package
  home.packages = with pkgs; [
    zinit
  ];
}
