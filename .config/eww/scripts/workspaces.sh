for i in $(hyprctl monitors | grep active | sed 's/()/(1)/g' | awk 'NR>1{print $1}' RS='(' FS=')'); do 
  	export active_workspace=$i
done

get_actv() {
	if [[ "$active_workspace" == $1 ]]; then
		echo "active"
	else
		echo "inactive"
	fi
}

socket() (
	if [[ ${1:0:9} == "workspace" ]]; then
		export active_workspace=${1:11}
		echo "	(box :class \"body\" :orientation \"h\" :space-evenly \"false\" :spacing 12 \
					(button :onclick \"hyprctl dispatch workspace 1\" :class \"$(get_actv 1)\" \"1\") \
					(button :onclick \"hyprctl dispatch workspace 2\" :class \"$(get_actv 2)\" \"2\") \
					(button :onclick \"hyprctl dispatch workspace 3\" :class \"$(get_actv 3)\" \"3\") \
					(button :onclick \"hyprctl dispatch workspace 4\" :class \"$(get_actv 4)\" \"4\") \
					(button :onclick \"hyprctl dispatch workspace 5\" :class \"$(get_actv 5)\" \"5\") \
					(button :onclick \"hyprctl dispatch workspace 6\" :class \"$(get_actv 6)\" \"6\") \
					(button :onclick \"hyprctl dispatch workspace 7\" :class \"$(get_actv 7)\" \"7\") \
					(button :onclick \"hyprctl dispatch workspace 8\" :class \"$(get_actv 8)\" \"8\") \
					(button :onclick \"hyprctl dispatch workspace 9\" :class \"$(get_actv 9)\" \"9\") \
					(button :onclick \"hyprctl dispatch workspace 0\" :class \"$(get_actv 0)\" \"0\") \
		)"
	fi
)

#init
socket "workspace>>$active_workspace" 

socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
socket "$event"
done
