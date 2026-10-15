{ lib, pkgs, config, ... }:

{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = "torrent";
    package = pkgs.qbittorrent-nox;
#    webuiPort = 8080;
  };  
}
