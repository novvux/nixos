{ config, ... }:

{
  networking.enableIPv6 = true;

#  networking.nameservers = [ "301:84f7:4bc0:2f3a::53" ];

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;

    settings = {
      Peers = [
        "quic://kursk.cleverfox.org:15015"
        "tcp://ygg-msk-1.averyan.ru:8363"
        "tcp://u-neroit.ru:7000"
        "tcp://37.192.232.33:8080"
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

  services.resolved = {
    enable = true;
    settings.Resolve = {
      Domains = [ "~ygg" "~anon" "~btn" "~conf" "~index" "~merch" "~mirror" "~mob" "~screen" "~srv" ];
      DNS = [ "[308:84:68:55::]:53" "[308:25:40:bd::]:53" "[308:62:45:62::]:53" ];
    };
  };
}
