{...}: {

  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      persistent-apps = [
        "/System/Applications/LaunchPad.app"
        "/Applications/Self-Service.app"
        "/Applications/Bitwarden.app"
        "/Applications/1Password.app"
        "/Applications/Obsidian.app"
        "/Applications/Slack.app"
        "/Applications/Arc.app"
        "/System/Applications/Utilities/Terminal.app"
        "/Applications/Visual Studio Code.app"
      ];
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # customize trackpad
    trackpad = {
      # tap - 轻触触摸板, click - 点击触摸板
      Clicking = true;  # enable tap to click(轻触触摸板相当于点击)
      TrackpadRightClick = true;  # enable two finger right click
      # TrackpadThreeFingerDrag = true;  # enable three finger drag
    };

    # Customize settings that not supported by nix-darwin directly
    # see the source code of this project to get more undocumented options:
    #    https://github.com/rgcr/m-cli
    # 
    # All custom entries can be found by running `defaults read` command.
    # or `defaults read xxx` to read a specific domain.
    CustomUserPreferences = {
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
    };
  };
}