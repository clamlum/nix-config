{ pkgs, username, ... }:
{
  boot.kernelModules = [ "mpls_router" "mpls_iptunnel" "sch_netem" ];

  virtualisation.docker.enable = true;
  programs.wireshark.enable = true;

  services.gns3-server = {
    enable = true;
    ubridge.enable = true;
    vpcs.enable = true;
    dynamips.enable = true;
  };

  systemd.services.gns3-server.serviceConfig.SupplementaryGroups = [ "docker" ];
  systemd.services.gns3-server.path = [ pkgs.docker ];

  environment.systemPackages = with pkgs; [ gns3-gui gns3-server inetutils xterm wireshark ];

  users.users.${username}.extraGroups = [ "ubridge" "docker" "wireshark" ];
}
