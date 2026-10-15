{ config, pkgs, ... }: 

{
  sops.secrets."frp-uvinsk-config" = {
    owner = "root";
    group = "root";
    mode = "0400";
    restartUnits = [ "frp-uvinsk.service" ];
  };

  services.frp.instances."uvinsk" = {
    enable = true;
    role = "client";
    environmentFiles = [ config.sops.secrets."frp-uvinsk-config".path ];
    settings = {
      serverAddr = "{{ .Envs.ADDR }}";
      serverPort = 7001;
      
      auth.method = "token";
      auth.token = "{{ .Envs.TOKEN }}";

      proxies = [
        {
          name = "ssh";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 22;
          remotePort = 6002;
        }

        # Services
        {
          name = "forgejo-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 3000;
          remotePort = 3000;
        }

        {
          name = "nextcloud-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 9200;
          remotePort = 9200;
        }

        {
          name = "jellyfin-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 8096;
          remotePort = 8096;
        }

        {
          name = "jellyfin-udp";
          type = "udp";
          localIP = "127.0.0.1";
          localPort = 7359;
          remotePort = 7359;
        }

        {
          name = "qbit-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 8080;
          remotePort = 8080;
        }

        {
           name = "wiki/mediawiki";
           type = "tcp";
           localIP = "127.0.0.1";
           localPort = 3004;
           remotePort = 3004;
        }

        # Games
        {
          name = "factorio-udp";
          type = "udp";
          localIP = "127.0.0.1";
          localPort = 34197;
          remotePort = 34197;
        }

        {
          name = "terraria-tmod";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 7777;
          remotePort = 7777;
        }

        {
          name = "terraria-minecraft";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 7778;
          remotePort = 7778;
        }

        {
          name = "minecraft-pumpkin-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 25565;
          remotePort = 25565;
        }

        {
          name = "minecraft-pumpkin-udp";
          type = "udp";
          localIP = "127.0.0.1";
          localPort = 25565;
          remotePort = 25565;
        }

        {
          name = "bedrock-pumpkin-tcp";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 19132;
          remotePort = 19132;
        }

        {
          name = "bedrock-pumpkin-udp";
          type = "udp";
          localIP = "127.0.0.1";
          localPort = 19132;
          remotePort = 19132;
        }

        {
          name = "satis-tcp-7777";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 7777;
          remotePort = 7777;
        }

        {
          name = "satis-udp-7777";
          type = "udp";
          localIP = "127.0.0.1";
          localPort = 7777;
          remotePort = 7777;
        }

        {
          name = "satis-tcp-8888";
          type = "tcp";
          localIP = "127.0.0.1";
          localPort = 8888;
          remotePort = 8888;
        }

        # User

        {
          name = "mitsuki-vm-ssh";
          type = "tcp";
          localIP = "10.0.0.66";
          localPort = 23;
          remotePort = 666;
        }
      ];
    };
  };
}
