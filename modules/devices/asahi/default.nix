{
  imports = [
    ./asahi.nix
    ./hardware-configuration.nix
    ./kernel.nix

    ../../services/wireguard.nix
  ];
}
