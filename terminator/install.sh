#!/bin/sh

# Current directory
DIR="$( cd "$( dirname "$0" )" && pwd )"

# Symlink config file (NOTE: this is intentionally done before root)
TERM_CONFIG="$HOME/.config/terminator/config"
if [ -f "$TERM_CONFIG" ]; then
	rm "$TERM_CONFIG"
fi

ln -s "$DIR/config" "$TERM_CONFIG"

# Run script as root
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Installs
apt-get install terminator
