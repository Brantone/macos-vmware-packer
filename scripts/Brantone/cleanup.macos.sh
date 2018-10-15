#!/bin/sh

# Originally pulled from:
# https://github.com/mcandre/packer-templates/blob/d23f3c75c86b5f544790aeca80210b3f570f9e7a/macos/cleanup.macos.sh

# Disable hibernation
pmset hibernatemode 0 && \
    rm -f /var/vm/sleepimage

# Disable power saving
pmset -a displaysleep 0 disksleep 0 sleep 0

# Disable screensaver
defaults -currentHost write com.apple.screensaver idleTime 0

# Clear cache
rm -rf /Users/vagrant/Library/Caches/* \
    /Library/Caches/*

# These aren't really delete-able .. thanks Apple.

# Uninstall non-critical applications
#rm -rf /Applications/Calculator.app \
#    /Applications/Calendar.app \
#    /Applications/Chess.app \
#    /Applications/Contacts.app \
#    /Applications/DVD\ Player.app \
#    /Applications/FaceTime.app \
#    /Applications/Mail.app \
#    /Applications/Maps.app \
#    /Applications/Notes.app \
#    /Applications/Photo\ Booth.app \
#    /Applications/QuickTime\ Player.app \
#    /Applications/Reminders.app \
#    /Applications/Safari.app \
#    /Applications/Siri.app \
#    /Applications/Stickies.app \
#    /Applications/iBooks.app \
#    /Applications/iTunes.app

# Uninstall voices
rm -rf /System/Library/Speech/Voices/*

# Clear bash history
rm /Users/vagrant/.bash_history

# Clear logs
rm -rf /private/var/log/*

# Clear temporary files
rm -rf /tmp/*
