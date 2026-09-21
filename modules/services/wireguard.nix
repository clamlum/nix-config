{ username, ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/etc/wireguard/wg0.conf";
      autostart = false;
    };
  };

  home-manager.users.clamt.home.file.".zshrc".text = ''
    function vpn() {
      if [[ $1 == "on" ]]; then
        sudo systemctl start wg-quick-wg0 && echo "VPN on"
      elif [[ $1 == "off" ]]; then
        sudo systemctl stop wg-quick-wg0 && echo "VPN off"
      elif [[ $1 == "restart" ]]; then
        sudo systemctl restart wg-quick-wg0 && echo "VPN restarted"
      elif [[ $1 == "status" ]]; then
        sudo wg show wg0
      else
        if systemctl is-active --quiet wg-quick-wg0; then
          sudo systemctl stop wg-quick-wg0 && echo "VPN off"
        else
          sudo systemctl start wg-quick-wg0 && echo "VPN on"
        fi
      fi
    }
  '';

  security.sudo.extraRules = [
    {
      users = [ username ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start wg-quick-wg0";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop wg-quick-wg0";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl restart wg-quick-wg0";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
