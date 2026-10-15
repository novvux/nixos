{ lib, pkgs, config, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "torrent";
    package = pkgs.jellyfin;
    configDir = "/storage/jellyfin/config";
#    cacheDir = "/storage/jellyfin/cache";
  };  

#  networking.firewall.allowedTCPPorts = [ 8096 ];
}
