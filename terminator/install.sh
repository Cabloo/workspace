#!/bin/bash

# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Variable setup
# $curr_dir: the path to this directory (terminator)
curr_dir="$( cd "$( dirname "$0" )" && pwd )"
curr_dir_var="{CURR_DIR}"

# $dir: the full path to the directory the workspace repo is stored in
dir="$(dirname -- "$(dirname -- "$curr_dir")")"
dir_var="{DIR}"
# $site: the name of the directory the workspace repo is stored in
site=$(basename -- "$dir")
site_var="{SITE}"

files_dir="$curr_dir/.files"

# Config file
cfg_dir="$HOME/.config/terminator"
cfg_file="$cfg_dir/config"
# TODO: Better way of checking if terminator is installed
if [[ ! -f "$cfg_file" ]]; then
	apt-get install terminator
fi

# If there's still no terminator config file after installing, add default one.
if [[ ! -f "$cfg_file" ]]; then
	mkdir -p "$cfg_dir"
	cp "$files_dir/sample.cfg" "$cfg_file"
fi

# Check if this site is already in the config file
grep -q "\[\[$site\]\]" "$cfg_file"
if [[ $? -eq 0 ]]; then
	echo "$site already found in $cfg_file, skipping..."
else
	echo "$site not found in $cfg_file, adding..."

	# Substitutions
	layouts=$(cat "$files_dir/layouts.cfg")
	layouts=${layouts//"$curr_dir_var"/"$curr_dir"}
	layouts=${layouts//"$dir_var"/"$dir"}
	layouts=${layouts//"$site_var"/"$site"}

	# Create empty config file
	tmp_cfg="/tmp/config"
	echo "" > "$tmp_cfg"

	# Read from current config file, and when [layouts] is found, add $layouts.
	while read -r line
	do
		echo -e "$line" >> "$tmp_cfg"
		echo $line | grep -q "\[layouts\]"
		[[ $? -eq 0 ]] && echo "$layouts" >> "$tmp_cfg"
	done < "$cfg_file"

	# Finally, copy over our temp file
	cp "$tmp_cfg" "$cfg_file"
fi


shell_file="$curr_dir/terminator.sh"
# Shell Script
if [[ ! -f "$shell_file" ]]; then
	sed "s#$site_var#$site#g" "$files_dir/terminator.sh" > "$shell_file"
	sed -i "s#$dir_var#$dir#g" "$shell_file"
	chmod +x "$shell_file"
	# TODO: Chown
fi


# Desktop shortcut
desktop_file="/usr/share/applications/${site}_terminator.desktop"
desktop_name=$(basename -- "$desktop_file")
if [[ ! -f "$desktop_file" ]]; then
	sed "s#$site_var#$site#g" "$files_dir/terminator.desktop" > "$desktop_file"
	chmod +x "$desktop_file"
fi

# If running on Ubuntu, add to sidebar
if hash gsettings 2>/dev/null; then
	favs=$(gsettings get com.canonical.Unity.Launcher favorites)
	# If not already on sidebar
	if [[ $favs != *"$desktop_name"* ]]; then
		echo "Adding to sidebar..."
		favs=${favs:0:-1}", 'application://$desktop_name']"
		gsettings set com.canonical.Unity.Launcher favorites "$favs"
		# TODO: Reload Unity
		# unity --replace
	fi
fi
