-------------------------------
--    "Sky" awesome theme    --
--  By Andrei "Garoth" Thorp --
-------------------------------
-- If you want SVGs and extras, get them from garoth.com/awesome/sky-theme

-- BASICS
local theme = {}
theme.font          = "sans 8"

theme.bg_focus      = "#e2eeea"
theme.bg_normal     = "#729fcf"
theme.bg_urgent     = "#fce94f"
theme.bg_minimize   = "#0067ce"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#2e3436"
theme.fg_focus      = "#2e3436"
theme.fg_urgent     = "#2e3436"
theme.fg_minimize   = "#2e3436"

theme.useless_gap   = 0
theme.border_width  = 2
theme.border_normal = "#dae3e0"
theme.border_focus  = "#729fcf"
theme.border_marked = "#eeeeec"

-- IMAGES
theme.layout_fairh           = "/usr/local/share/awesome/themes/sky/layouts/fairh.png"
theme.layout_fairv           = "/usr/local/share/awesome/themes/sky/layouts/fairv.png"
theme.layout_floating        = "/usr/local/share/awesome/themes/sky/layouts/floating.png"
theme.layout_magnifier       = "/usr/local/share/awesome/themes/sky/layouts/magnifier.png"
theme.layout_max             = "/usr/local/share/awesome/themes/sky/layouts/max.png"
theme.layout_fullscreen      = "/usr/local/share/awesome/themes/sky/layouts/fullscreen.png"
theme.layout_tilebottom      = "/usr/local/share/awesome/themes/sky/layouts/tilebottom.png"
theme.layout_tileleft        = "/usr/local/share/awesome/themes/sky/layouts/tileleft.png"
theme.layout_tile            = "/usr/local/share/awesome/themes/sky/layouts/tile.png"
theme.layout_tiletop         = "/usr/local/share/awesome/themes/sky/layouts/tiletop.png"
theme.layout_spiral          = "/usr/local/share/awesome/themes/sky/layouts/spiral.png"
theme.layout_dwindle         = "/usr/local/share/awesome/themes/sky/layouts/dwindle.png"
theme.layout_cornernw        = "/usr/local/share/awesome/themes/sky/layouts/cornernw.png"
theme.layout_cornerne        = "/usr/local/share/awesome/themes/sky/layouts/cornerne.png"
theme.layout_cornersw        = "/usr/local/share/awesome/themes/sky/layouts/cornersw.png"
theme.layout_cornerse        = "/usr/local/share/awesome/themes/sky/layouts/cornerse.png"

theme.awesome_icon           = "/usr/local/share/awesome/themes/sky/awesome-icon.png"

-- from default for now...
theme.menu_submenu_icon     = "/usr/local/share/awesome/themes/default/submenu.png"
theme.taglist_squares_sel   = "/usr/local/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/local/share/awesome/themes/default/taglist/squarew.png"

-- MISC
theme.wallpaper             = "/usr/local/share/awesome/themes/sky/sky-background.png"
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height           = 15
theme.menu_width            = 100

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/local/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/usr/local/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = "/usr/local/share/awesome/themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "/usr/local/share/awesome/themes/default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/local/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/usr/local/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/local/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/usr/local/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/local/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/usr/local/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/local/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/usr/local/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/local/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/usr/local/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/local/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/usr/local/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/local/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/usr/local/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/local/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/usr/local/share/awesome/themes/default/titlebar/maximized_focus_active.png"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
