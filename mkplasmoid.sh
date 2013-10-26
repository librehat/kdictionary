#!/bin/sh

ver=`grep "X-KDE-PluginInfo-Version" metadata.desktop | sed 's/.*=//'`

zip ~/kdictionary-$ver.plasmoid -r contents
zip ~/kdictionary-$ver.plasmoid metadata.desktop COPYING README.md