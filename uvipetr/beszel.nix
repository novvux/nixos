{ config, pkgs, ... }:

{
  sops.secrets."beszel" = {
    owner = "root";
    group = "root";
    mode = "0400";
    restartUnits = [ "beszel-agent.service" ];
  };

  services.beszel = {
    hub = {
      enable = true;
      host = "0.0.0.0";
#      port = 8090;

      dataDir = "/storage/beszel";
    };

    agent = {
      enable = true;
      smartmon.enable = true;
      openFirewall = true;
      environmentFile = config.sops.secrets."beszel".path;
    };
  };  

  networking.firewall = {
    allowedTCPPorts = [ 8090 ];
  };
}
