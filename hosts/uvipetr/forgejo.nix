{ lib, pkgs, config, ... }:

let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  services.forgejo = {
    enable = false;
    package = pkgs.forgejo;

    # Why I'm defining default values
    database = {
      type = "postgres";
#      user = "forgejo";
#      name = "forgejo";
#      host = "127.0.0.1";
#      port = "5432";
    };

    lfs.enable = true;
    stateDir = "/storage/git/forgejo";
    customDir = "/storage/git/conf";
    repositoryRoot = "/storage/git/forgejo/git/repositories";

    settings = {
      server = {
#        DOMAIN = "xn--c1ak4a.xn--b1aqiqh3c.xn--p1ai";
#        ROOT_URL = "https://${srv.DOMAIN}/"; 
        DOMAIN = "200:a229:85fc:67e8:271c:277c:5e29:6589";
        ROOT_URL = "http://[200:a229:85fc:67e8:271c:277c:5e29:6589]:3000/";
        HTTP_PORT = 3000;
        HTTP_ADDR = "::";
      };
      service.DISABLE_REGISTRATION = false; 

      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration 
 #     mailer = {
 #       ENABLED = true;
 #       SMTP_ADDR = "mail.example.com";
 #       FROM = "noreply@${srv.DOMAIN}";
 #       USER = "noreply@${srv.DOMAIN}";
 #     };
    };
#    secrets = {
#      mailer.PASSWD = config.age.secrets.forgejo-mailer-password.path;
#    };
  };

#  age.secrets.forgejo-mailer-password = {
#    file = ../secrets/forgejo-mailer-password.age;
#    mode = "400";
#    owner = "forgejo";
#  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
