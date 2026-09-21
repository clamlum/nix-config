{ pkgs, config, ... }:
{
  systemd.services.patched-modules = {
    description = "Load patched out-of-tree modules (ath12k, spi-geni-qcom)";
    wantedBy = [ "sysinit.target" ];
    after = [ "systemd-modules-load.service" ];
    before = [ "systemd-udev-trigger.service" "network-pre.target" "sysinit.target" ];
    unitConfig.DefaultDependencies = false;
    restartIfChanged = false;
    path = [ pkgs.kmod ];
    environment.MODULE_DIR = "/run/booted-system/kernel-modules/lib/modules";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ver=${config.boot.kernelPackages.kernel.modDirVersion}
      d=/run/booted-system/kernel-modules/lib/modules/$ver/extra

      load() {
        f="$d/$1.ko"
        for dep in $(modinfo -F depends "$f" | tr ',' ' '); do
          modprobe "$dep" || true
        done
        insmod "$f" || echo "failed to insmod $1"
      }

      rmmod ath12k_wifi7 ath12k spi_geni_qcom 2>/dev/null || true
      load ath12k
      load ath12k_wifi7
      load spi-geni-qcom
      modprobe spi-hid || true
    '';
  };

  systemd.services.bt-public-addr = {
    description = "Set stable Bluetooth public address";
    wantedBy = [ "bluetooth.service" ];
    before = [ "bluetooth.service" ];
    path = [ pkgs.bluez pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = 40;
    };
    script = ''
      for i in $(seq 1 20); do
        [ -e /sys/class/bluetooth/hci0 ] && break
        sleep 1
      done
      timeout 10 btmgmt --index 0 public-addr 02:11:22:33:44:55
    '';
  };

  systemd.services.trigger-touchpad = {
    description = "Trigger touchpad";
    wantedBy = [ "multi-user.target" ];
    after = [ "patched-modules.service" ];
    requires = [ "patched-modules.service" ];
    path = [ pkgs.systemd pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for i in $(seq 1 30); do
        ls /dev/hidraw* >/dev/null 2>&1 && break
        sleep 1
      done
      udevadm settle --timeout=10
      udevadm trigger --subsystem-match=hidraw --action=add
      udevadm settle --timeout=10
    '';
  };
}
