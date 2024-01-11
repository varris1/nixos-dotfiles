{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    xdgOpenUsePortal = false;
    wlr.enable = false; #conflict with XDPH if enabled
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
