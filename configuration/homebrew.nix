{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    
    # CLI packages
    brews = [
      "awscli"
      "stow"
      "tfenv"
    ];

    # GUI applications
    casks = [
      "alt-tab"
      "arc"
      "beekeeper-studio"
      "brave-browser"
      "grammarly-desktop"
      "logi-options+"
      "obsidian"
      "ollama"
      "slack"
      "stats"
      "visual-studio-code"
    ];

    masApps = {
      "bitwarden" = 1352778147;
      "whatsapp-messenger" = 310633997;
    };
  };
}