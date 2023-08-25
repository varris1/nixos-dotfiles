{ pkgs, ... }:
{
  workspaces = pkgs.writeShellScriptBin "workspaces.sh" ''
    workspaces() {

    unset -v \
    o1 o2 o3 o4 o5 o6  \
    f1 f2 f3 f4 f5 f6 

    ows="$(${pkgs.hyprland}/bin/hyprctl workspaces -j | ${pkgs.jq}/bin/jq '.[] | del(select(.id == -99)) | .id')"

    for num in $ows; do
      export o"$num"="$num"
    done

    # Get Focused workspace for current monitor ID
    arg="$1"
    num="$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq --argjson arg "$arg" '.[] | select(.id == $arg).activeWorkspace.id')"
    export f"$num"="$num"

    if [[ $arg -eq 0 ]]; then
      echo 	"(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
                (box	:class \"workspace\"	:orientation \"h\" :space-evenly \"false\" 	\
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 1\" :class \"w0$o1$f1\" \"1\") \
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 2\" :class \"w0$o2$f2\" \"2\") \
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 3\" :class \"w0$o3$f3\" \"3\") \
                )\
              )"
    elif [[ $arg -eq 1 ]]; then
      echo 	"(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
                (box	:class \"workspace\"	:orientation \"h\" :space-evenly \"false\" 	\
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 4\" :class \"w0$o4$f4\" \"4\") \
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 5\" :class \"w0$o5$f5\" \"5\") \
                    (button :onclick \"${pkgs.hyprland}/bin/hyprctl dispatch workspace 6\" :class \"w0$o6$f6\" \"6\") \
                )\
              )"
    fi
    }

    workspaces $1 
    ${pkgs.socat}/bin/socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do 
    workspaces $1
    done
  '';
  
  mpd-current-song = pkgs.writeShellScriptBin "mpd_current_song.sh" ''
    currentsong=""
    state=""

    while true; do
      state=$(${pkgs.mpc-cli}/bin/mpc status %state%)
      current_song=$(${pkgs.mpc-cli}/bin/mpc current)

      if [[ $state == "playing" ]]; then
        echo " $current_song"
      elif [[ $state == "paused" && $current_song ]]; then
        echo "󰏤 $current_song"
      else
        echo " stopped"
      fi
      ${pkgs.mpc-cli}/bin/mpc idle player &> /dev/null
    done
  '';

  get-volume = pkgs.writeShellScriptBin "get_volume.sh" ''
    volume=$(${pkgs.pamixer}/bin/pamixer --get-volume)

    if [[ $volume -eq 0 ]]; then
      echo " $volume%"
    elif [[ $volume -lt 25 ]]; then
      echo " $volume%"
    elif [[ $volume -lt 50 ]]; then
      echo " $volume%"
    elif [[ $volume -lt 75 ]]; then
      echo "󰕾 $volume%"
    else
      echo " $volume%"
    fi
  '';
}
