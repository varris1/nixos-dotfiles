#!/usr/bin/env cached-nix-shell
#! nix-shell -i bash -p hyprland socat jq

workspaces() {

unset -v \
o1 o2 o3 o4 o5 o6  \
f1 f2 f3 f4 f5 f6 

ows="$(hyprctl workspaces -j | jq '.[] | del(select(.id == -99)) | .id')"

for num in $ows; do
  export o"$num"="$num"
done

# Get Focused workspace for current monitor ID
arg="$1"
num="$(hyprctl monitors -j | jq --argjson arg "$arg" '.[] | select(.id == $arg).activeWorkspace.id')"
export f"$num"="$num"

if [[ $arg -eq 0 ]]; then
  echo 	"(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
            (box	:class \"workspace\"	:orientation \"h\" :space-evenly \"false\" 	\
                (button :onclick \"hyprctl dispatch workspace 1\" :class \"w0$o1$f1\" \"1\") \
                (button :onclick \"hyprctl dispatch workspace 2\" :class \"w0$o2$f2\" \"2\") \
                (button :onclick \"hyprctl dispatch workspace 3\" :class \"w0$o3$f3\" \"3\") \
            )\
          )"
  elif [[ $arg -eq 1 ]]; then
    echo 	"(eventbox :onscroll \"echo {} | sed -e 's/up/-1/g' -e 's/down/+1/g' | xargs hyprctl dispatch workspace\" \
              (box	:class \"workspace\"	:orientation \"h\" :space-evenly \"false\" 	\
                  (button :onclick \"hyprctl dispatch workspace 4\" :class \"w0$o4$f4\" \"4\") \
                  (button :onclick \"hyprctl dispatch workspace 5\" :class \"w0$o5$f5\" \"5\") \
                  (button :onclick \"hyprctl dispatch workspace 6\" :class \"w0$o6$f6\" \"6\") \
              )\
          )"
fi
}

workspaces $1 
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do 
workspaces $1
done