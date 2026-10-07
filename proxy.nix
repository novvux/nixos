{ config, pkgs, ... }:

#{
#  services.proxy-suite = {
#    enable = true;
#
#    tgWsProxy = {
#      enable = true;
#      listener.port = 8443;
#      secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
#      fakeTlsDomain = "4pda.to";
#    };

#    zapret = {
#      enable = true;
#      zapret-discord-youtube = {
#        configName = "general (ALT9)";
#        domains = [ "nixos.org" "chaotic.cx" "cachix.org" ];
#      };
#    };
#  };
#}


let
  # 1. THE FIX: Use the actual Google ClientHello file.
  # Nix will fail on the first build and output the correct hash. 
  # Replace the dummy hash below with the one Nix provides.
  tlsClientHelloGoogle = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/tls_clienthello_www_google_com.bin";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; 
  };

  stun2 = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/stun2.bin";
    sha256 = "b7c2497496039c541f7337ac8536813f0a1cf52363ab2faa5213b7816d458813";
  };

  tlsClientHello5ka = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/tls_clienthello_5ka_ru.bin";
    sha256 = "066h13n6h6cg5qb8b3pm3k5zxhcpymm1d9iqglkml72rfbi7320y";
  };

  hostlistUserExclude = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/ipset/zapret-hosts-user-exclude.txt";
    sha256 = "a55a5780c31f91fae51602e548cdfb6b4e0badfe40365a708a5a0ff82a1fc69d";
  };
in
{
  services.proxy-suite = {
    enable = true;

    tgWsProxy = {
      enable = true;
      listener.port = 8443;
      secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      fakeTlsDomain = "4pda.to";
    };

    zapret = {
      enable = true;
      engine = "zapret-discord-youtube";

      zapret-discord-youtube = {
        # "general (ALT11)" or "general (ALT9)" are currently the most stable for YouTube.
        configName = "general (ALT11)";

        # If the built-in preset above works, DELETE the `hostlistRules` block entirely.
        /*
        hostlistRules = [
          {
            name = "google-custom";
            defaultDomains = [ "google" ]; # Covers youtube.com and googlevideo.com
            nfqwsArgs = [
              "--filter-tcp=443"
              "--ip-id=zero"
              "--dpi-desync=fake,multisplit"
              "--dpi-desync-split-seqovl=681"
              "--dpi-desync-split-pos=1"
              "--dpi-desync-fooling=ts"
              "--dpi-desync-repeats=8"
              "--dpi-desync-split-seqovl-pattern=${tlsClientHelloGoogle}" # <-- Fixed to use Google bin
              "--dpi-desync-fake-tls=${stun2}"
            ];
          }
          {
            name = "general-fallback";
            defaultDomains = [ "general" ];
            nfqwsArgs = [
              "--filter-tcp=80,443"
              "--hostlist-exclude=${hostlistUserExclude}"
              "--dpi-desync=fake,multisplit"
              "--dpi-desync-split-seqovl=652"
              "--dpi-desync-split-pos=2"
              "--dpi-desync-fooling=ts"
              "--dpi-desync-repeats=12"
              "--dpi-desync-split-seqovl-pattern=${tlsClientHello5ka}"
              "--dpi-desync-fake-tls=${stun2}"
              "--dpi-desync-fake-tls=${tlsClientHello5ka}"
              "--dpi-desync-fake-http=${tlsClientHello5ka}"
            ];
          }
        ];
        */
      };
    };
  };
}
