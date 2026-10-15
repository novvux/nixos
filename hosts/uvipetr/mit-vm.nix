# Этот файл полностью завайбкожен и не проверялся на адекватность

{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.qemu_kvm ];

  # Мост 10.0.0.1/24 — «провод» между хостом и VM
  systemd.network = {
    enable = true;
    netdevs."10-br-mitsuki".netdevConfig = { Kind = "bridge"; Name = "br-mitsuki"; };
    networks."10-br-mitsuki" = {
      matchConfig.Name = "br-mitsuki";
      address = [ "10.0.0.1/24" ];
    };
  };

  # Не отдаем мост и TAP NetworkManager'у, ими рулит networkd
  networking.networkmanager.unmanaged = [ "interface-name:br-mitsuki" "interface-name:tap-mitsuki" ];

  # TAP для VM — создается при загрузке, владелец Mitsuki
  systemd.services.tap-mitsuki = {
    description = "TAP device for Mitsuki VM";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-networkd.service" ];
    serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };
    script = ''
      ${pkgs.iproute2}/bin/ip tuntap add dev tap-mitsuki mode tap user Mitsuki group users || true
      ${pkgs.iproute2}/bin/ip link set tap-mitsuki master br-mitsuki
      ${pkgs.iproute2}/bin/ip link set tap-mitsuki up
    '';
    preStop = "${pkgs.iproute2}/bin/ip tuntap del dev tap-mitsuki mode tap || true";
  };

  # NAT наружу через основной интерфейс
  networking.nat = {
    enable = true;
    internalInterfaces = [ "br-mitsuki" ];
    externalInterface = "enp4s0";
  };

  # Хост не фильтрует этот провод — какие порты видны с хоста,
  # решает фаервол САМОЙ VM (т.е. я, своим конфигом)
  networking.firewall.trustedInterfaces = [ "br-mitsuki" ];
  networking.hosts."10.0.0.66" = [ "mitsuki-vm" ];

  systemd.services.mitsuki-vm = {
    description = "Mitsuki micro-VM (tap @ 10.0.0.66)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "tap-mitsuki.service" ];
    requires = [ "tap-mitsuki.service" ];

    serviceConfig = {
      User = "Mitsuki";
      Group = "users";
      RuntimeDirectory = "mitsuki-vm";
      Restart = "always";
      RestartSec = 10;

      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /storage/Mitsuki/shared";
      ExecStart = builtins.concatStringsSep " " [
        "${pkgs.qemu_kvm}/bin/qemu-kvm"
        "-name mitsuki-vm"
        "-machine accel=kvm"
        "-cpu host"
        "-smp 4,maxcpus=8"
        "-m 4096,slots=2,maxmem=12G"
        "-display none"
        "-monitor none"
        "-serial stdio"
        "-drive file=/storage/Mitsuki/rootfs/vm.qcow2,if=virtio,format=qcow2,discard=unmap"
        "-drive file=/storage/Mitsuki/data.qcow2,if=virtio,format=qcow2,discard=unmap"
        "-device virtio-balloon-pci"
        "-device virtio-serial-pci"
        "-chardev socket,path=/run/mitsuki-vm/qga.sock,server=on,wait=off,id=agent0"
        "-device virtserialport,chardev=agent0,name=org.qemu.guest_agent.0"
        "-virtfs local,path=/storage/Mitsuki/shared,mount_tag=hostshare,security_model=mapped"
        "-netdev tap,id=net0,ifname=tap-mitsuki,script=no,downscript=no"
        "-device virtio-net-pci,netdev=net0,mac=52:54:00:00:00:66"
      ];
    };
  };
}
