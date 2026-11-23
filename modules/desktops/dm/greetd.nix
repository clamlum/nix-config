{ pkgs, lib, config, device, ... }:
let
  greeterScale = {
    nixos = "1";
    asahi = "1.8";
    surface = "1.6";
  }.${device};

  users = (lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser) config.users.users)) ++ [ "root" ];

  sessionDir = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";

  greeterData = pkgs.runCommand "greeter-data.json"
    {
      nativeBuildInputs = [ pkgs.jq ];
      usersJson = builtins.toJSON users;
      shellCmd = "${pkgs.bashInteractive}/bin/zsh";
    }
    ''
      shopt -s nullglob
      for f in ${sessionDir}/*.desktop; do
        name=$(sed -n 's/^Name=//p' "$f" | head -n1)
        exec=$(sed -n 's/^Exec=//p' "$f" | head -n1)
        jq -n --arg name "$name" --arg exec "$exec" '{
          name: $name,
          command: ($exec | split(" ") | map(select(startswith("%") | not)))
        }'
      done | jq -s . > sessions.json

      jq -n \
        --argjson users "$usersJson" \
        --slurpfile sessions sessions.json \
        --arg shell "$shellCmd" '{
          users: $users,
          sessions: ($sessions[0] + [{ name: "shell", command: [$shell, "-l"] }])
        }' > $out
    '';
in
{
  systemd.services.greeter-wallpaper = {
    wantedBy = [ "multi-user.target" ];
    before = [ "greetd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "-${pkgs.coreutils}/bin/install -Dm644 ${config.vars.wallpaperPath} /var/lib/greeter/wallpaper";
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/greeter 0755 greeter greeter -" ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = "${pkgs.cage}/bin/cage -d -s -m last -- env QT_SCALE_FACTOR=${greeterScale} QT_WAYLAND_DISABLE_WINDOWDECORATION=1 WALLPAPER_PATH=/var/lib/greeter/wallpaper GREETER_DATA=${greeterData} GREETER_STATE=/var/lib/greeter/state.json ${pkgs.quickshell}/bin/quickshell -p ${../../../resources/quickshell}/greeter.qml";
    };
  };
}
