{ config, pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18; # Use a recent stable version
    
    # Declare all the databases your consolidated services need
    ensureDatabases = [ "forgejo" "nextcloud" ];
    
    # Create the users and grant them ownership of their respective databases
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }

      {
        name = "nextcloud";
        ensureDBOwnership = true;
#        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];

    authentication = pkgs.lib.mkOverride 10 ''
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
    '';
  };
}
