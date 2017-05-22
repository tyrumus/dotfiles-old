---------------------------
-- Default awesome theme --
---------------------------
profileConfigPath = "/home/legostax/.config/awesome/"
local theme = {}

theme.font          = "Roboto 10"
-- shelf bg: #31373a
-- shelf blue: #2375c3
-- shelf light gray: #767d80
-- shelf white: #fefefe
theme.bg_normal     = "#31373a"
theme.window_bg_normal = "#3d4346"
theme.window_bg_focus = "#31373a"
theme.bg_focus      = "#4082f7"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = "#232729"

theme.fg_normal     = "#aaaaaa"
theme.window_fg_normal = "#aaa"
theme.fg_focus      = "#ffffff"
theme.window_fg_focus = "#aaa"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = 0
theme.border_width  = 0
theme.border_normal = "#8d8d8d"
theme.border_focus  = "#8d8d8d"
theme.border_marked = "#8d8d8d"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = profileConfigPath.."themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = profileConfigPath.."themes/default/taglist/squarew.png"

-- Tasklist stuffs
theme.tasklist_plain_task_name = true
theme.tasklist_disable_task_name = true

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = profileConfigPath.."themes/default/submenu.png"
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = profileConfigPath.."themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_normal_hover = profileConfigPath.."themes/default/titlebar/close_normal_hover.png"
theme.titlebar_close_button_normal_press = profileConfigPath.."themes/default/titlebar/close_normal_press.png"
theme.titlebar_close_button_focus  = profileConfigPath.."themes/default/titlebar/close_focus.png"
theme.titlebar_close_button_focus_hover = profileConfigPath.."themes/default/titlebar/close_focus_hover.png"
theme.titlebar_close_button_focus_press = profileConfigPath.."themes/default/titlebar/close_focus_press.png"

theme.titlebar_minimize_button_normal = profileConfigPath.."themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_normal_hover = profileConfigPath.."themes/default/titlebar/minimize_normal_hover.png"
theme.titlebar_minimize_button_normal_press = profileConfigPath.."themes/default/titlebar/minimize_normal_press.png"
theme.titlebar_minimize_button_focus  = profileConfigPath.."themes/default/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_focus_hover = profileConfigPath.."themes/default/titlebar/minimize_focus_hover.png"
theme.titlebar_minimize_button_focus_press = profileConfigPath.."themes/default/titlebar/minimize_focus_press.png"

theme.titlebar_maximized_button_normal_inactive = profileConfigPath.."themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_normal_inactive_hover = profileConfigPath.."themes/default/titlebar/maximized_normal_inactive_hover.png"
theme.titlebar_maximized_button_normal_inactive_press = profileConfigPath.."themes/default/titlebar/maximized_normal_inactive_press.png"
theme.titlebar_maximized_button_focus_inactive  = profileConfigPath.."themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_focus_inactive_hover = profileConfigPath.."themes/default/titlebar/maximized_focus_inactive_hover.png"
theme.titlebar_maximized_button_focus_inactive_press = profileConfigPath.."themes/default/titlebar/maximized_focus_inactive_press.png"

theme.titlebar_maximized_button_normal_active = profileConfigPath.."themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_normal_active_hover = profileConfigPath.."themes/default/titlebar/maximized_normal_active_hover.png"
theme.titlebar_maximized_button_normal_active_press = profileConfigPath.."themes/default/titlebar/maximized_normal_active_press.png"
theme.titlebar_maximized_button_focus_active  = profileConfigPath.."themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_focus_active_hover = profileConfigPath.."themes/default/titlebar/maximized_focus_active_hover.png"
theme.titlebar_maximized_button_focus_active_press = profileConfigPath.."themes/default/titlebar/maximized_focus_active_press.png"

theme.wallpaper = profileConfigPath.."wallpapers/default.png"

-- You can use your own layout icons like this:
theme.layout_fairh = profileConfigPath.."themes/default/layouts/fairhw.png"
theme.layout_fairv = profileConfigPath.."themes/default/layouts/fairvw.png"
theme.layout_floating  = profileConfigPath.."themes/default/layouts/floatingw.png"
theme.layout_magnifier = profileConfigPath.."themes/default/layouts/magnifierw.png"
theme.layout_max = profileConfigPath.."themes/default/layouts/maxw.png"
theme.layout_fullscreen = profileConfigPath.."themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = profileConfigPath.."themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = profileConfigPath.."themes/default/layouts/tileleftw.png"
theme.layout_tile = profileConfigPath.."themes/default/layouts/tilew.png"
theme.layout_tiletop = profileConfigPath.."themes/default/layouts/tiletopw.png"
theme.layout_spiral  = profileConfigPath.."themes/default/layouts/spiralw.png"
theme.layout_dwindle = profileConfigPath.."themes/default/layouts/dwindlew.png"
theme.layout_cornernw = profileConfigPath.."themes/default/layouts/cornernww.png"
theme.layout_cornerne = profileConfigPath.."themes/default/layouts/cornernew.png"
theme.layout_cornersw = profileConfigPath.."themes/default/layouts/cornersww.png"
theme.layout_cornerse = profileConfigPath.."themes/default/layouts/cornersew.png"

theme.awesome_icon = profileConfigPath.."newui/applauncher.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Paper"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
