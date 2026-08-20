{ config, ... }:

{
  networking.enableIPv6 = true;

#  networking.nameservers = [ "301:84f7:4bc0:2f3a::53" ];

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;

    settings = {
      Peers = [
        # Public seed peers (update occasionally if one goes offline).
        "quic://ip4.fvm.mywire.org:443?key=000000000143db657d1d6f80b5066dd109a4cb31f7dc6cb5d56050fffb014217"
        "tls://yggdrasil.neilalexander.dev:64648?key=ecbbcb3298e7d3b4196103333c3e839cfe47a6ca47602b94a6d596683f6bb358"
        "ws://ekb.itrus.su:7994"
        "tcp://185.188.183.161:2048"
        "quic://185.188.183.161:4096"
      ];

      # Do not accept inbound peer sessions by default.
      Listen = [ ];
    };

    # Allow the primary user to query the local admin socket with yggdrasilctl.
#    users.users.${user}.extraGroups = [ "yggdrasil" ];
  };
}
