{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = false; #conflict with XDPH if enabled
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
