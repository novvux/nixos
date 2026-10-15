{ lib, config, pkgs, ... }:

# Интернет-радио по иггдрасилю
# Оригинальная статья: http://[320:9c1:e1fa:a105::d]/yggdrasil:internet_radio

let
  # Define your passwords here. CHANGE THESE!
  sourcePassword = "change_me_source_pass";
  relayPassword  = "change_me_relay_pass";
  adminPassword  = "change_me_admin_pass";
in
{
  services.icecast = {
    enable = true;
    hostname = "localhost"; 
    admin.user = "admin";
    admin.password = adminPassword;
    listen.address = "::"; 
    listen.port = 8000;
    
    extraConfig = ''
      <authentication>
        <source-password>${sourcePassword}</source-password>
        <relay-password>${relayPassword}</relay-password>
      </authentication>
      <mount type="default">
        <password>${sourcePassword}</password>
      </mount>
      <limits>
        <clients>200</clients>
        <sources>4</sources>
      </limits>
    '';
  };

  services.liquidsoap.streams.radio = pkgs.writeText "radio.liq" ''
    settings.log.stdout := true
    settings.log.file := false
    settings.log.level := 3

    music = playlist("/cache/radio-liquidsoap/state/radio.m3u")
    radio = fallback(track_sensitive=false, [music, blank()])

    output.icecast(
      %opus(bitrate=128),
      host = "127.0.0.1",
      port = 8000,
      user = "source",
      password = "${sourcePassword}",
      mount = "radio.opus",
      name = "Yggdrasil Radio",
      description = "24/7 Streaming over Yggdrasil",
      genre = "Mixed",
      radio
    )
  '';

  users.users.liquidsoap.extraGroups = [ "torrent" ];

  networking.firewall.allowedTCPPorts = [ 8000 ];
}
