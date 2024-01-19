{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    # package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;

    profiles.${config.home.username} = {
      extensions = with config.nur.repos.rycee.firefox-addons; [
        augmented-steam
        bitwarden
        blocktube
        bypass-paywalls-clean
        darkreader
        gruvbox-dark-theme
        indie-wiki-buddy
        istilldontcareaboutcookies
        nitter-redirect
        privacy-badger
        redirector
        return-youtube-dislikes
        sponsorblock
        stylus
        tampermonkey
        ublock-origin
        youtube-shorts-block
      ];

      settings = {
        "general.smoothScroll" = false;
        "media.hardwaremediakeys.enabled" = false;
      };

      bookmarks = [
        {
          toolbar = true;
          bookmarks = [
            {
              name = "NixOS";
              bookmarks = [
                {
                  name = "NixOS Search";
                  url = "https://search.nixos.org";
                }
                {
                  name = "Home Manager Options List";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "Home Manager Options Search";
                  url = "https://mipmip.github.io/home-manager-option-search";
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
