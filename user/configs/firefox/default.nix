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
        privacy-badger
        redirector
        return-youtube-dislikes
        sponsorblock
        startpage-private-search
        stylus
        tampermonkey
        ublock-origin
        vimium
        youtube-shorts-block
      ];

      settings = {
        "general.smoothScroll" = false;
        "media.hardwaremediakeys.enabled" = false;
        "browser.download.useDownloadDir" = false;
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
                  name = "NUR Search";
                  url = "https://nur.nix-community.org";
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
