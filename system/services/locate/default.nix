{
  pkgs,
  lib,
  ...
}: {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
    prunePaths = lib.mkOptionDefault [];
    interval = "hourly";
  };
}
