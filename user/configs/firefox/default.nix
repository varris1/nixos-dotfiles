{config, ...}: {
  programs.firefox = {
    enable = true;

    profiles.${config.home.username} = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
        augmented-steam
        bypass-paywalls-clean
        darkreader
        gruvbox-dark-theme
        nitter-redirect
        redirector
        sponsorblock
        startpage-private-search
        ublock-origin
        youtube-shorts-block
      ];

      settings = {
        "media.hardwaremediakeys.enabled" = false;
      };
    };
  };
               }
