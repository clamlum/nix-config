{
  pkgs,
  device,
  username,
  ...
}:

{
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.users.${username} = {
    services.swayidle = {
      enable = true;
      events = {
        lock = "${pkgs.quickshell}/bin/qs ipc call lock activate";
        before-sleep = "${pkgs.quickshell}/bin/qs ipc call lock activate";
      };
      timeouts =
        [ ]
        ++ (
          if device == "asahi" then
            [
              {
                timeout = 300;
                command = "${pkgs.quickshell}/bin/qs ipc call lock activate";
              }
              {
                timeout = 310;
                command = "${pkgs.systemd}/bin/systemctl suspend";
              }
            ]
          else
            [ ]
        );
    };
  };
}
