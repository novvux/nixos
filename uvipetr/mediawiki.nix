{ lib, pkgs, config, ... }:


let
  clearDomain = "xn--b1amah.xn--b1aqiqh3c.xn--p1ai";
  localAddr = "192.168.1.7";
  yggAddr = "200:a229:85fc:67e8:271c:277c:5e29:6589";
in
{
  services.mediawiki = {
    enable = true;
    name = "Увывики";

    webserver = "nginx";
    nginx.hostName = clearDomain;
    database.type = "sqlite";

    uploadsDir = "/cache/mediawiki/uploads";

    # А пароль изменён
    passwordFile = pkgs.writeText "password" "cardbotnine";
    passwordSender = "No@donotcontact.com";

#    extraConfig = ''
#      # Disable anonymous editing
#      $wgGroupPermissions['*']['edit'] = false;
#    '';

    extraConfig = ''
      $wgLanguageCode = "ru";

      # ── Dynamic server detection ──────────────────────────────
      # Override the auto-generated $wgServer so MediaWiki uses
      # whatever Host header the client sent. This means:
      #   - Clearnet users get links like https://wiki.yourdomain.com/...
      #   - Yggdrasil users get links like http://[200:abcd:...]/...
      $wgServer = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http')
                 . '://' . $_SERVER['HTTP_HOST'];
 
      $wgCanonicalServer = "https://${clearDomain}";

      $wgCrossSiteAJAXdomains = [ '${clearDomain}', '[${yggAddr}]' ];

      $wgLogos = [
       '1x' => "{$wgUploadPath}/w/images/4/4a/Wiki-logo.jpg",
        # 'icon' => "{$wgUploadPath}/x/xx/NewLogoIcon.png", 
      ];

      $wgDefaultSkin = 'timeless'; 
    '';

    extensions = {
      AbuseFilter = null;
      CategoryTree = null;
      CodeEditor = null;
      ConfirmEdit = null;
      DiscussionTools = null;
      Echo = null;
      Gadgets = null;
      InputBox = null;
      Linter = null;
      Math = null;
      MultimediaViewer = null;
      PageImages = null;
      Poem = null;
      ReplaceText = null;
      SpamBlacklist = null;
      TemplateData = null;
      TemplateStyles = null;
      Thanks = null;
      TitleBlacklist = null;
      VisualEditor = null;
      WikiEditor = null;
    };
  };

  services.nginx.virtualHosts.${clearDomain} = {
    serverAliases = [ 
      localAddr
      "[${yggAddr}]" # Nginx requires IPv6 addresses in server_name to be bracketed
    ];

    listen = [
      { addr = "0.0.0.0"; port = 3004; }
      { addr = "[::]";    port = 3004; }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 3004 ];
}
