{ osConfig, ... }:

{
  programs.plasma = {
    enable = true;

    workspace = {
      colorScheme = "BreezeDark";
    };

    panels = [
      {
        location = "bottom";
        height = 40;
        floating = true;
        hiding = "autohide";
        screen = 0;

        widgets = [
          {
            kickoff = {
              icon = "nixos";
            };
          }
          {
            iconTasks = { };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray = { };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
        ];
      }
      {
        location = "bottom";
        height = 40;
        floating = true;
        hiding = "none";
        screen = 1;

        widgets = [
          {
            kickoff = {
              icon = "nixos";
            };
          }
          {
            iconTasks = { };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray = { };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
        ];
      }
    ];

    shortcuts = {
      ActivityManager.switch-to-activity-a63bb97e-770b-4321-8b69-f3d2e4ed41b9 = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      kaccess."Toggle Screen Reader On and Off" = [ ];
      kmix.decrease_microphone_volume = "Microphone Volume Down";
      kmix.decrease_volume = "Volume Down";
      kmix.decrease_volume_small = "Shift+Volume Down";
      kmix.increase_microphone_volume = "Microphone Volume Up";
      kmix.increase_volume = "Volume Up";
      kmix.increase_volume_small = "Shift+Volume Up";
      kmix.mic_mute = [
        "Microphone Mute"
        "Meta+Volume Mute"
      ];
      kmix.mute = "Volume Mute";
      kmix.push_to_talk = [ ];
      ksmserver."Halt Without Confirmation" = [ ];
      ksmserver."Lock Session" = [
        "Screensaver"
        "Meta+L"
      ];
      ksmserver."Log Out" = "Ctrl+Alt+Del";
      ksmserver."Log Out Without Confirmation" = [ ];
      ksmserver.LogOut = [ ];
      ksmserver.Reboot = [ ];
      ksmserver."Reboot Without Confirmation" = [ ];
      ksmserver."Shut Down" = [ ];
      kwin."Activate Window Demanding Attention" = [ ];
      kwin."Cycle Overview" = [ ];
      kwin."Cycle Overview Opposite" = [ ];
      kwin."Decrease Opacity" = [ ];
      kwin."Edit Tiles" = [ ];
      kwin.Expose = [
        "Ctrl+F9"
        "Meta+F9"
      ];
      kwin.ExposeAll = [
        "Launch (C)"
        "Ctrl+F10"
        "Meta+F10"
      ];
      kwin.ExposeClass = [
        "Ctrl+F7"
        "Meta+F7"
      ];
      kwin.ExposeClassCurrentDesktop = [ ];
      kwin."Grid View" = "Meta+G";
      kwin."Increase Opacity" = [ ];
      kwin."Kill Window" = [ ];
      kwin."Move Tablet to Next LogicalOutput" = [ ];
      kwin.MoveMouseToCenter = [ ];
      kwin.MoveMouseToFocus = [ ];
      kwin.MoveZoomDown = [ ];
      kwin.MoveZoomLeft = [ ];
      kwin.MoveZoomRight = [ ];
      kwin.MoveZoomUp = [ ];
      kwin.Overview = "Meta+W";
      kwin."Setup Window Shortcut" = [ ];
      kwin."Show Desktop" = [ ];
      kwin."Switch One Desktop Down" = [ ];
      kwin."Switch One Desktop Up" = [ ];
      kwin."Switch One Desktop to the Left" = [ ];
      kwin."Switch One Desktop to the Right" = [ ];
      kwin."Switch Window Down" = "Meta+Alt+Down";
      kwin."Switch Window Left" = "Meta+Alt+Left";
      kwin."Switch Window Right" = "Meta+Alt+Right";
      kwin."Switch Window Up" = "Meta+Alt+Up";
      kwin."Switch to Desktop 1" = [ ];
      kwin."Switch to Desktop 10" = [ ];
      kwin."Switch to Desktop 11" = [ ];
      kwin."Switch to Desktop 12" = [ ];
      kwin."Switch to Desktop 13" = [ ];
      kwin."Switch to Desktop 14" = [ ];
      kwin."Switch to Desktop 15" = [ ];
      kwin."Switch to Desktop 16" = [ ];
      kwin."Switch to Desktop 17" = [ ];
      kwin."Switch to Desktop 18" = [ ];
      kwin."Switch to Desktop 19" = [ ];
      kwin."Switch to Desktop 2" = [ ];
      kwin."Switch to Desktop 20" = [ ];
      kwin."Switch to Desktop 21" = [ ];
      kwin."Switch to Desktop 22" = [ ];
      kwin."Switch to Desktop 23" = [ ];
      kwin."Switch to Desktop 24" = [ ];
      kwin."Switch to Desktop 25" = [ ];
      kwin."Switch to Desktop 3" = [ ];
      kwin."Switch to Desktop 4" = [ ];
      kwin."Switch to Desktop 5" = [ ];
      kwin."Switch to Desktop 6" = [ ];
      kwin."Switch to Desktop 7" = [ ];
      kwin."Switch to Desktop 8" = [ ];
      kwin."Switch to Desktop 9" = [ ];
      kwin."Switch to Next Desktop" = [ ];
      kwin."Switch to Next Screen" = [ ];
      kwin."Switch to Previous Desktop" = [ ];
      kwin."Switch to Previous Screen" = [ ];
      kwin."Switch to Screen 0" = [ ];
      kwin."Switch to Screen 1" = [ ];
      kwin."Switch to Screen 2" = [ ];
      kwin."Switch to Screen 3" = [ ];
      kwin."Switch to Screen 4" = [ ];
      kwin."Switch to Screen 5" = [ ];
      kwin."Switch to Screen 6" = [ ];
      kwin."Switch to Screen 7" = [ ];
      kwin."Switch to Screen Above" = [ ];
      kwin."Switch to Screen Below" = [ ];
      kwin."Switch to Screen to the Left" = [ ];
      kwin."Switch to Screen to the Right" = [ ];
      kwin."Toggle Night Color" = [ ];
      kwin."Toggle Window Raise/Lower" = [ ];
      kwin."Walk Through Windows" = "Alt+Tab";
      kwin."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      kwin."Walk Through Windows Alternative" = [ ];
      kwin."Walk Through Windows Alternative (Reverse)" = [ ];
      kwin."Walk Through Windows of Current Application" = [ ];
      kwin."Walk Through Windows of Current Application (Reverse)" = [ ];
      kwin."Walk Through Windows of Current Application Alternative" = [ ];
      kwin."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];
      kwin."Window Above Other Windows" = [ ];
      kwin."Window Below Other Windows" = [ ];
      kwin."Window Close" = "Meta+Q";
      kwin."Window Custom Quick Tile Bottom" = [ ];
      kwin."Window Custom Quick Tile Left" = [ ];
      kwin."Window Custom Quick Tile Right" = [ ];
      kwin."Window Custom Quick Tile Top" = [ ];
      kwin."Window Fullscreen" = "Meta+Shift+F";
      kwin."Window Grow Horizontal" = [ ];
      kwin."Window Grow Vertical" = [ ];
      kwin."Window Lower" = [ ];
      kwin."Window Maximize" = [
        "Meta+F"
        "Meta+Up"
      ];
      kwin."Window Maximize Horizontal" = [ ];
      kwin."Window Maximize Vertical" = [ ];
      kwin."Window Minimize" = "Meta+Down";
      kwin."Window Move" = [ ];
      kwin."Window Move Center" = [ ];
      kwin."Window No Border" = [ ];
      kwin."Window On All Desktops" = [ ];
      kwin."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      kwin."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      kwin."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      kwin."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      kwin."Window One Screen Down" = [ ];
      kwin."Window One Screen Up" = [ ];
      kwin."Window One Screen to the Left" = [ ];
      kwin."Window One Screen to the Right" = [ ];
      kwin."Window Operations Menu" = "Alt+F3";
      kwin."Window Pack Down" = [ ];
      kwin."Window Pack Left" = [ ];
      kwin."Window Pack Right" = [ ];
      kwin."Window Pack Up" = [ ];
      kwin."Window Quick Tile Bottom" = [ ];
      kwin."Window Quick Tile Bottom Left" = [ ];
      kwin."Window Quick Tile Bottom Right" = [ ];
      kwin."Window Quick Tile Left" = "Meta+Left";
      kwin."Window Quick Tile Right" = "Meta+Right";
      kwin."Window Quick Tile Top" = [ ];
      kwin."Window Quick Tile Top Left" = [ ];
      kwin."Window Quick Tile Top Right" = [ ];
      kwin."Window Raise" = [ ];
      kwin."Window Resize" = [ ];
      kwin."Window Restore" = "Meta+Backspace";
      kwin."Window Shrink Horizontal" = [ ];
      kwin."Window Shrink Vertical" = [ ];
      kwin."Window to Desktop 1" = "Meta+!";
      kwin."Window to Desktop 10" = "Meta+)";
      kwin."Window to Desktop 11" = [ ];
      kwin."Window to Desktop 12" = [ ];
      kwin."Window to Desktop 13" = [ ];
      kwin."Window to Desktop 14" = [ ];
      kwin."Window to Desktop 15" = [ ];
      kwin."Window to Desktop 16" = [ ];
      kwin."Window to Desktop 17" = [ ];
      kwin."Window to Desktop 18" = [ ];
      kwin."Window to Desktop 19" = [ ];
      kwin."Window to Desktop 2" = "Meta+@";
      kwin."Window to Desktop 20" = [ ];
      kwin."Window to Desktop 21" = [ ];
      kwin."Window to Desktop 22" = [ ];
      kwin."Window to Desktop 23" = [ ];
      kwin."Window to Desktop 24" = [ ];
      kwin."Window to Desktop 25" = [ ];
      kwin."Window to Desktop 3" = "Meta+#";
      kwin."Window to Desktop 4" = "Meta+$";
      kwin."Window to Desktop 5" = "Meta+%";
      kwin."Window to Desktop 6" = "Meta+^";
      kwin."Window to Desktop 7" = "Meta+&";
      kwin."Window to Desktop 8" = "Meta+*";
      kwin."Window to Desktop 9" = "Meta+(";
      kwin."Window to Next Desktop" = [ ];
      kwin."Window to Next Screen" = [ ];
      kwin."Window to Previous Desktop" = [ ];
      kwin."Window to Previous Screen" = [ ];
      kwin."Window to Screen 0" = [ ];
      kwin."Window to Screen 1" = [ ];
      kwin."Window to Screen 2" = [ ];
      kwin."Window to Screen 3" = [ ];
      kwin."Window to Screen 4" = [ ];
      kwin."Window to Screen 5" = [ ];
      kwin."Window to Screen 6" = [ ];
      kwin."Window to Screen 7" = [ ];
      kwin.disableInputCapture = "Meta+Shift+Esc";
      kwin.view_actual_size = [ ];
      kwin.view_zoom_in = [
        "Meta++"
        "Meta+="
      ];
      kwin.view_zoom_out = "Meta+-";
      mediacontrol.mediavolumedown = [ ];
      mediacontrol.mediavolumeup = [ ];
      mediacontrol.nextmedia = "Media Next";
      mediacontrol.pausemedia = "Media Pause";
      mediacontrol.playmedia = [ ];
      mediacontrol.playpausemedia = "Media Play";
      mediacontrol.previousmedia = "Media Previous";
      mediacontrol.seekbackwardmedia = "Media Rewind";
      mediacontrol.seekbackwardmedialong = [ ];
      mediacontrol.seekforwardmedia = "Media Fast Forward";
      mediacontrol.seekforwardmedialong = [ ];
      mediacontrol.stopmedia = "Media Stop";
      org_kde_powerdevil."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      org_kde_powerdevil."Decrease Screen Brightness" = "Monitor Brightness Down";
      org_kde_powerdevil."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      org_kde_powerdevil.Hibernate = "Hibernate";
      org_kde_powerdevil."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      org_kde_powerdevil."Increase Screen Brightness" = "Monitor Brightness Up";
      org_kde_powerdevil."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      org_kde_powerdevil.PowerDown = "Power Down";
      org_kde_powerdevil.PowerOff = "Power Off";
      org_kde_powerdevil.Sleep = "Sleep";
      org_kde_powerdevil."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      org_kde_powerdevil."Turn Off Screen" = [ ];
      org_kde_powerdevil.powerProfile = [
        "Battery"
        "Meta+B"
      ];
      plasmashell."Slideshow Wallpaper Next Image" = [ ];
      plasmashell."activate application launcher" = [ ];
      plasmashell."activate task manager entry 1" = [ ];
      plasmashell."activate task manager entry 10" = [ ];
      plasmashell."activate task manager entry 2" = [ ];
      plasmashell."activate task manager entry 3" = [ ];
      plasmashell."activate task manager entry 4" = [ ];
      plasmashell."activate task manager entry 5" = [ ];
      plasmashell."activate task manager entry 6" = [ ];
      plasmashell."activate task manager entry 7" = [ ];
      plasmashell."activate task manager entry 8" = [ ];
      plasmashell."activate task manager entry 9" = [ ];
      plasmashell."clear history" = [ ];
      plasmashell.clear-history = [ ];
      plasmashell.clipboard_action = "Meta+Ctrl+X";
      plasmashell.cycle-panels = [ ];
      plasmashell.cycleNextAction = [ ];
      plasmashell.cyclePrevAction = [ ];
      plasmashell.edit_clipboard = [ ];
      plasmashell."manage activities" = [ ];
      plasmashell."next activity" = "Meta+A";
      plasmashell."previous activity" = "Meta+Shift+A";
      plasmashell.repeat_action = [ ];
      plasmashell."show dashboard" = "Ctrl+F12";
      plasmashell.show-barcode = [ ];
      plasmashell.show-on-mouse-pos = "Meta+V";
      plasmashell."switch to next activity" = [ ];
      plasmashell."switch to previous activity" = [ ];
      plasmashell."toggle do not disturb" = [ ];
      "services/com.mitchellh.ghostty.desktop"._launch = [ ];
      "services/helium-browser.desktop"._launch = "Meta+D";
      "services/net.local.fuzzel-edit.sh.desktop"._launch = "Meta+Shift+Space";
      "services/net.local.fuzzel.desktop"._launch = "Meta+Space";
      "services/net.local.wpctl.desktop"._launch = "Num+-";
      "services/org.kde.konsole.desktop"._launch = [ ];
      "services/org.kde.krunner.desktop".RunClipboard = [ ];
      "services/org.kde.krunner.desktop"._launch = [ ];
      "services/org.kde.kscreen.desktop".ShowOSD = [ ];
      "services/org.kde.plasma-systemmonitor.desktop"._launch = "Ctrl+Shift+Esc";
      "services/org.kde.spectacle.desktop".ActiveWindowScreenShot = [ ];
      "services/org.kde.spectacle.desktop".CurrentMonitorScreenShot = "Meta+S";
      "services/org.kde.spectacle.desktop".FullScreenScreenShot = [ ];
      "services/org.kde.spectacle.desktop".OpenWithoutScreenshot = [ ];
      "services/org.kde.spectacle.desktop".RecordRegion = [ ];
      "services/org.kde.spectacle.desktop".RecordScreen = [ ];
      "services/org.kde.spectacle.desktop".RecordWindow = [ ];
      "services/org.kde.spectacle.desktop".RectangularRegionScreenShot = "Meta+Shift+S";
      "services/org.kde.spectacle.desktop".WindowUnderCursorScreenShot = [ ];
      "services/org.kde.spectacle.desktop"._launch = [ ];
      "services/org.wezfurlong.wezterm.desktop"._launch = "Meta+T";
    };
    configFile = {
      baloofilerc.General.dbVersion = 2;
      dolphinrc.General.ViewPropsTimestamp = "2026,5,17,5,34,3.822";
      dolphinrc."KFileDialog Settings"."Places Icons Auto-resize" = false;
      dolphinrc."KFileDialog Settings"."Places Icons Static Size" = 22;
      kactivitymanagerdrc.activities.a63bb97e-770b-4321-8b69-f3d2e4ed41b9 = "Default";
      kded5rc.Module-device_automounter.autoload = false;
      kdeglobals.General.AccentColor = "67,109,196";
      kdeglobals.General.LastUsedCustomAccentColor = "61,174,233";
      kdeglobals.General.UseSystemBell = true;
      kdeglobals.General.accentColorFromWallpaper = true;
      kdeglobals.KDE.AnimationDurationFactor = 0;
      kdeglobals.KDE.contrast = 4;
      kdeglobals.KDE.frameContrast = 0.2;
      kdeglobals."KFileDialog Settings"."Allow Expansion" = false;
      kdeglobals."KFileDialog Settings"."Automatically select filename extension" = true;
      kdeglobals."KFileDialog Settings"."Breadcrumb Navigation" = true;
      kdeglobals."KFileDialog Settings"."Decoration position" = 2;
      kdeglobals."KFileDialog Settings"."Show Full Path" = false;
      kdeglobals."KFileDialog Settings"."Show Inline Previews" = true;
      kdeglobals."KFileDialog Settings"."Show Preview" = false;
      kdeglobals."KFileDialog Settings"."Show Speedbar" = true;
      kdeglobals."KFileDialog Settings"."Show hidden files" = false;
      kdeglobals."KFileDialog Settings"."Sort by" = "Name";
      kdeglobals."KFileDialog Settings"."Sort directories first" = true;
      kdeglobals."KFileDialog Settings"."Sort hidden files last" = false;
      kdeglobals."KFileDialog Settings"."Sort reversed" = false;
      kdeglobals."KFileDialog Settings"."Speedbar Width" = 148;
      kdeglobals."KFileDialog Settings"."View Style" = "DetailTree";
      kdeglobals.WM.activeBackground = "39,44,49";
      kdeglobals.WM.activeBlend = "252,252,252";
      kdeglobals.WM.activeForeground = "252,252,252";
      kdeglobals.WM.inactiveBackground = "32,36,40";
      kdeglobals.WM.inactiveBlend = "161,169,177";
      kdeglobals.WM.inactiveForeground = "161,169,177";
      ksmserverrc.General.confirmLogout = false;
      ksmserverrc.General.loginMode = "emptySession";
      kuriikwsfilterrc.General.EnableWebShortcuts = true;
      kuriikwsfilterrc.General.KeywordDelimiter = ":";
      kuriikwsfilterrc.General.PreferredWebShortcuts = "";
      kuriikwsfilterrc.General.UsePreferredWebShortcutsOnly = false;
      kwalletrc.Wallet."Close When Idle" = false;
      kwalletrc.Wallet."Close on Screensaver" = false;
      kwalletrc.Wallet.Enabled = true;
      kwalletrc.Wallet."First Use" = false;
      kwalletrc.Wallet."Idle Timeout" = 10;
      kwalletrc.Wallet."Launch Manager" = false;
      kwalletrc.Wallet."Leave Manager Open" = false;
      kwalletrc.Wallet."Leave Open" = true;
      kwalletrc.Wallet."Prompt on Open" = false;
      kwalletrc.Wallet."Use One Wallet" = true;
      kwalletrc."org.freedesktop.secrets".apiEnabled = true;
      kwinrc.Desktops.Id_1 = "457ab456-b2a4-42de-ad94-034ddb59541c";
      kwinrc.Desktops.Id_10 = "92eb9b7a-10f3-46c4-ad23-971c3d5dceb6";
      kwinrc.Desktops.Id_2 = "46fbceaa-440e-46a8-bc4a-6a41a1dcad9b";
      kwinrc.Desktops.Id_3 = "2ec6cdaf-172c-4450-9888-46bbff15223d";
      kwinrc.Desktops.Id_4 = "6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd";
      kwinrc.Desktops.Id_5 = "3066265d-2556-4cfa-8455-514e18f0dda8";
      kwinrc.Desktops.Id_6 = "c3d0c802-b693-49e0-98dc-9ab37d0205fd";
      kwinrc.Desktops.Id_7 = "1184a5ce-be59-4b01-aa11-f9ee495f6ce4";
      kwinrc.Desktops.Id_8 = "68d1c49c-ce73-47bc-942a-bd1063480683";
      kwinrc.Desktops.Id_9 = "22b03028-1498-4ede-827e-fc1f66ed76da";
      kwinrc.Desktops.Number = 10;
      kwinrc.Desktops.Rows = 1;
      kwinrc.EdgeBarrier.EdgeBarrier = 0;
      kwinrc.Effect-overview.BorderActivate = 9;
      kwinrc.Plugins.shakecursorEnabled = false;
      kwinrc.Plugins.slideEnabled = false;
      kwinrc.TabBox.HighlightWindows = false;
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/1184a5ce-be59-4b01-aa11-f9ee495f6ce4/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/22b03028-1498-4ede-827e-fc1f66ed76da/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/2ec6cdaf-172c-4450-9888-46bbff15223d/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/3066265d-2556-4cfa-8455-514e18f0dda8/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/457ab456-b2a4-42de-ad94-034ddb59541c/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/46fbceaa-440e-46a8-bc4a-6a41a1dcad9b/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/68d1c49c-ce73-47bc-942a-bd1063480683/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/6a3b7523-9938-47e6-8b8e-4bd0ee66d8dd/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/92eb9b7a-10f3-46c4-ad23-971c3d5dceb6/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/4968d33b-3c76-478b-8e25-cc7db4a1afe3".padding =
        4;
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/4968d33b-3c76-478b-8e25-cc7db4a1afe3".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".padding =
        4;
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/9bcb8e18-d5fa-4336-8a75-fcc656a3ff88".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/c6e6d9a5-ba21-42bc-a045-22289e602285".padding =
        4;
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/c6e6d9a5-ba21-42bc-a045-22289e602285".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/f619e1f1-63b6-4c40-a500-a3a33d0831e5".padding =
        4;
      kwinrc."Tiling/c3d0c802-b693-49e0-98dc-9ab37d0205fd/f619e1f1-63b6-4c40-a500-a3a33d0831e5".tiles =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":x5b{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}x5d}";
      kwinrc.Windows.AutoRaiseInterval = 0;
      kwinrc.Windows.DelayFocusInterval = 0;
      kwinrc.Windows.NextFocusPrefersMouse = true;
      kwinrc.Windows.Placement = "Smart";
      kwinrc.Windows_HDR.MaxLuminance = 530;
      kwinrc.Windows_HDR.Reference = 480;
      kwinrc.Xwayland.Scale = 1.1833333333333333;
      kwinrulesrc.General.rules = "";
      kxkbrc.Layout.Options = "caps:none";
      kxkbrc.Layout.ResetOldOptions = true;
      plasma-localerc.Formats.LANG = "en_US.UTF-8";
      plasmanotifyrc."Applications/discord".Seen = true;
      plasmarc.Wallpapers.usersWallpapers = osConfig.vars.wallpaperPath;
      spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      spectaclerc.ImageSave.imageSaveLocation = "file:///dev/null";
      spectaclerc.ImageSave.lastImageSaveLocation = "file:///home/clamt/Pictures/Screenshots/Screenshot_20260517_212334.png";
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
    };
    dataFile = {

    };
  };
}
