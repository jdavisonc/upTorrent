#!/bin/bash
#
# Simple script to install upTorrent.sh
#
INSTALL_PATH=/usr/local/share/upTorrent

# Install dependencies
apt-get install curl libnotify-bin

# Copy all data
mkdir $INSTALL_PATH
cp .* $INSTALL_PATH/.

# Create configuration file
cp upTorrent.conf ~/.config/.

# Install desktop entry
cp upTorrent.desktop ~/.local/share/applications/

# Make symbolic link
cd /usr/local/bin
ln -s $INSTALL_PATH/upTorrent.sh upTorrent