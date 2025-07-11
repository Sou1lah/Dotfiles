#!/bin/bash
set -euo pipefail

gsettings get org.gnome.desktop.input-sources mru-sources | pcregrep -o1 "\[\('.+?, '(.+?)'" | tr [:lower:] [:upper:]
