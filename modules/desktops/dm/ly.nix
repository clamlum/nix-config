{
  pkgs,
  lib,
  device,
  ...
}:
let
  kmsconTty = "1";
  fontSize = if device == "asahi" then 18 else 16;
in
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "dur_file";
      dur_file_path = "/etc/ly/blackhole.dur";

      bg = "0x00000000";
      fg = "0x00FFFFFF";
      error_bg = "0x00000000";
      error_fg = "0x01FF0000";
      border_fg = "0x00FFFFFF";

      setup_cmd = "";
    };
  };

  environment.etc."ly/blackhole.dur".source = ../../../resources/ly/blackhole.dur;

  systemd.services.ly.enable = lib.mkForce false;
  systemd.services."display-manager".enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.ly ];

  services.kmscon = {
    enable = true;
  };

  systemd.services."kmsconvt@".aliases = lib.mkForce [ ];
  systemd.suppressedSystemUnits = lib.mkForce [ ];
  systemd.targets.getty.wants = lib.mkForce [ ];

  systemd.services."kmsconvt@${kmsconTty}" = {
    enable = true;
    overrideStrategy = "asDropin";

    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-user-sessions.service" ];

    serviceConfig = {
      ExecStart = lib.mkForce [
        ""
        "${pkgs.kmscon}/bin/kmscon --vt=tty${kmsconTty} --font-engine=freetype --font-size=${toString fontSize} --login -- ${pkgs.ly}/bin/ly --use-kmscon-vt"
      ];
    };
  };

  security.pam.services.kmscon.text = lib.mkForce ''
    account required pam_permit.so
    auth required pam_permit.so
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
    session optional pam_systemd.so class=greeter type=tty
  '';

  systemd.services."getty@${kmsconTty}".enable = lib.mkForce false;
  systemd.services."autovt@${kmsconTty}".enable = lib.mkForce false;
}
