{ pkgs, ... }:
let
  inherit (import ./scripts.nix { inherit pkgs; }) workspaces mpd-current-song get-volume;
in
{
  panel-config = 
  ''
      ;; ----------------------------- right monitor
      (defwidget bar0 []
        (centerbox
          :class "panel"
          :orientation "h"
          (left_side0)
          (center)
          (right_side)
        )
      )

      (defwidget left_side0 []
        (box
          :space-evenly false
          :orientation "h"
          :spacing 5

          (box
           :class "wswidget"
           :spacing 0
            (workspaces0)
          )

          (box 
            :class { window0 != "" ? "panel-widget-window" : "" }
            window0)
        )
      )

      ;; ----------------------------- left monitor

      (defwidget bar1 []
        (centerbox
          :class "panel"
          :orientation "h"
          (left_side1)
          (center)
          (right_side)
        )
      )

      (defwidget left_side1 []
        (box
          :space-evenly false
          :orientation "h"
          :spacing 5

          (box
           :class "wswidget"
           :spacing 0
            (workspaces1)
          )

          (box 
            :class { window1 != "" ? "panel-widget-window" : "" }
            window1)
        )
      )

      ;; -----------------------------

      (defwidget center []
        (box
          :space-evenly false
          :spacing 5

          (eventbox
            :onscroll "pamixer `echo {} | sed 's/up/\-i/\' | sed 's/down/\-d/'` 10"
            (box
              :space-evenly false
              :class "panel-widget-volume"
              volume))

          (box 
            :space-evenly false
            :class "mpd"
            mpd)
        )
      )

      (defwidget right_side []
        (box 
        :space-evenly false
        :spacing 5
        :halign "end"

         ;; (box
         ;;  :class "tray"
         ;;  (tray))

        (box 
          :space-evenly false
          :orientation "h"
          :class "date"
          date)
        )
      )

      ;; ---------------------------- workspace widget

      (deflisten workspace0
        "${workspaces}/bin/workspaces.sh 0")

      (defwidget workspaces0 []
        (literal :content workspace0))

      (deflisten workspace1
        "${workspaces}/bin/workspaces.sh 1")

      (defwidget workspaces1 []
        (literal :content workspace1))

      ;; ---------------------------- window widget

      (deflisten window0 "${pkgs.eww-hyprland-activewindow}/bin/hyprland-activewindow `${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r \".[0].name\"`")
      (deflisten window1 "${pkgs.eww-hyprland-activewindow}/bin/hyprland-activewindow `${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r \".[1].name\"`")

      (defwidget title0 []
          (label :text "''${window0}"))

      (defwidget title1 []
          (label :text "''${window1}"))

      ;; -----------------------------

      (defpoll volume
        :initial ""
        :interval "0.1s"
        "${get-volume}/bin/get_volume.sh")

      (deflisten mpd
        :initial ""
        "${mpd-current-song}/bin/mpd_current_song.sh")

      (defpoll date
        :interval "1s"
        "date '+%a %d, %B  %H:%M'")

      (defwidget tray []
        (systray 
        :pack-direction "ltr"
        :icon-size 22
        ))

      (defwindow bar0
        :monitor 0
        :windowtype "dock"
        :geometry 
        (geometry :x "0%"
                            :y "0%"
                            :width "100%"
                            :height "32px"
                            :anchor "top center")
                            :exclusive true
        (bar0))

      (defwindow bar1
        :monitor 1
        :windowtype "dock"
        :geometry 
        (geometry :x "0%"
                            :y "0%"
                            :width "100%"
                            :height "32px"
                            :anchor "top center")
                            :exclusive true
        (bar1))
    '';
}
