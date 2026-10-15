{ config, pkgs, ... }:

{
  services.factorio = {
    enable = true;
    description = "Каждому по ракете в лицо";
    game-name = "Uvinsk";
    saveName = "server";
    admins = [ "barvlad1210" "nepoopatop2" "CrackGg" ];
    openFirewall = true;
    package = pkgs.factorio-headless;
#    autosave-interval = 60;
    requireUserVerification = false;
  };
}
