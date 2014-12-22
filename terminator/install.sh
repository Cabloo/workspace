#!/bin/sh

# Symlink config file (NOTE: this is intentionally done before root)
$TERM_CONFIG="~/.config/terminator/config"
rm $TERM_CONFIG
ln -s config $TERM_CONFIG

# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Installs
apt-get install terminator
