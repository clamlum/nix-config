{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.wireguard-tools
  ];

  home-manager.users.clamt.home.file.".zshrc".text = ''
    function vpn() {
      local CONFIG="/etc/wireguard/wg0.conf"
      
      if [[ $1 == "on" ]]; then
        sudo wg-quick up "$CONFIG" && echo "VPN on"
      elif [[ $1 == "off" ]]; then
        sudo wg-quick down "$CONFIG" && echo "VPN off"
      elif [[ $1 == "restart" ]]; then
        sudo wg-quick down "$CONFIG" && sudo wg-quick up "$CONFIG" && echo "VPN restarted"
      elif [[ $1 == "status" ]]; then
        sudo wg show wg0
      else
        # Toggle: check if wg0 interface is currently active
        if sudo wg show | grep -q "^interface: wg0"; then
          sudo wg-quick down "$CONFIG" && echo "VPN off"
        else
          sudo wg-quick up "$CONFIG" && echo "VPN on"
        fi
      fi
    }
  '';

  # 3. nix-darwin syntax for passwordless sudo
  security.sudo.extraConfig = ''
    clamt ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/wg-quick, /run/current-system/sw/bin/wg
  '';
}
