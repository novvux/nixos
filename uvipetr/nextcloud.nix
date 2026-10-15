{ lib, pkgs, config, ... }:

let
  clearDomain = "xn--80ab2acne.xn--b1aqiqh3c.xn--p1ai";
  yggAddr = "200:a229:85fc:67e8:271c:277c:5e29:6589";
in
{
  sops.secrets."nextcloud" = {
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0400";
    restartUnits = [ "phpfpm-nextcloud.service" "nextcloud-setup.service" ];
  };

#  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
#    listen = [
#      { addr = "0.0.0.0"; port = 9200; }
#    ];
    
#    forceSSL = false;
#    enableACME = false;
#  };

  services.nginx.virtualHosts.${clearDomain} = {
    serverAliases = [ yggAddr ];

    listen = [
      { addr = "0.0.0.0"; port = 9200; }
      { addr = "[::]"; port = 9200; }
    ];

    forceSSL = false;
    enableACME = false;
  };

  networking.firewall.allowedTCPPorts = [ 9200 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud35;
    hostName = clearDomain;

    https = false;
    datadir = "/storage/nextcloud/data";

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks notes;
    };
    extraAppsEnable = true;
    appstoreEnable = true;

    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "oc_admin";
      dbpassFile = config.sops.secrets."nextcloud".path;
      dbhost = "localhost";
      adminuser = null;
    };

    settings = {
      # Some sane defaults required to satisfy Nextcloud configuration check
#      maintenance_window_start = 1;

      trusted_domains = [
        "192.168.1.7:9200"
        clearDomain
        "[${yggAddr}]"
        "[${yggAddr}]:9200"
      ];
      
      # Optional but recommended: ensures CLI commands and background jobs 
      # generate correct public links using your clearnet domain
#      overwrite.cli.url = "https://${config.services.nextcloud.hostName}";

      log_type = "systemd";
      serverid = 0;
      default_phone_region = "RU";
    };

    configureRedis = true;
    caching = {
      redis = true;
      apcu = true;
    };
  };
}
