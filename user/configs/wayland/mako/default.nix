{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 5000;

    width = 440;
    height = 320;

    backgroundColor = "#282828B3";
    borderColor = "#665C54ff";
    textColor = "#ebdbb2";
    progressColor = "over #665c54";
    borderRadius = 6;
    borderSize = 2;

    font = "JetBrainsMono Nerd Font Regular 10";
  };
}
