{ host
, lib
, config
, pkgs
, ...
}: {
  system = {
    defaults = {
      smb.NetBIOSName = host.hostname;

      dock = {
        orientation = "left";
        tilesize = 48;
        autohide = true;
        show-recents = true;
        mineffect = "genie";
        static-only = false;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/App Store.app"
          "/Applications/Safari.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Calculator.app"
        ];
        persistent-others = [
          #
        ];
        # Disable hot corners
        wvous-bl-corner = 2;
        wvous-br-corner = 4;
        wvous-tl-corner = 11;
        wvous-tr-corner = 12;
      };

      finder = {
        FXPreferredViewStyle = "clmv";
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXSortFoldersFirst = true;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;
        # TODO showweek
      };

      screencapture = {
        disable-shadow = true;
        location = "~/Desktop";
      };


      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 30; # seconds
      };

      trackpad = {
        ActuationStrength = 1;
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };

      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          AppleICUForce24HourTime = true;
          AppleInterfaceStyleSwitchesAutomatically = true;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
          AppleScrollerPagingBehavior = true; # Jump to the spot that’s clicked on the scroll bar
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = true;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
        };

        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        "com.apple.controlcenter" = {
          BatteryShowPercentage = false;
        };

        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        # Prevent Photos from opening automatically when devices are plugged in
        "com.apple.ImageCapture".disableHotPlug = true;

        "com.apple.dock" = let
          # for modifier support, check https://github.com/LnL7/nix-darwin/issues/998
          modifiers = {
            none = 0;
            option = 524288;
            cmd = 1048576;
            "option+cmd" = 1573864;
          };
        in {
          scroll-to-open = true;
          wvous-tl-modifier = modifiers.cmd;
          wvous-bl-modifier = modifiers.cmd;
          wvous-tr-modifier = modifiers.cmd;
          wvous-br-modifier = modifiers.cmd;
        };

        "com.apple.finder" = {
          AppleShowAllFiles = true;
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
        };

        "com.apple.Safari" = {
          # TODO not working under Sequoia(15.0)
          # ShowFullURLInSmartSearchField = true;
        };
      };
    };
  };
}
