#!/usr/bin/python

import gtk
import sys

# arguments: gtk-icon.py <icon_name> <icon_size>
icon_name = sys.argv[1]
icon_size = int(sys.argv[2])
icon_theme = gtk.icon_theme_get_default()
icon = icon_theme.lookup_icon(icon_name, icon_size, 0)
if icon:
    print icon.get_filename()
else:
    print "0"
