{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "clamt" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu - - - - ${pkgs.qemu}/share/qemu" ];

  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    dnsmasq
    bridge-utils
    nftables
    docker-compose
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  boot.kernelModules = [
    "bridge"
    "br_netfilter"
    "tun"
    "nf_nat"
    "iptable_nat"
  ];

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  programs.zsh.shellAliases = {
    docker = "podman";
  };
}
