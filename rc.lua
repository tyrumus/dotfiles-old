-- Standard awesome library
local gears = require("gears")
local timer = require("gears.timer")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Common.lua
local common = require("awful.widget.common")
local dpi = require("beautiful").xresources.apply_dpi


-- {{{ Edit these variables to your liking
profileConfigPath = "/home/legostax/.config/awesome/"
-- Wallpapers: [1] = morning, [2] = daytime, [3] = evening, [4] = night
wallpapers = {
    profileConfigPath.."wallpapers/morning.png",
    profileConfigPath.."wallpapers/day.png",
    profileConfigPath.."wallpapers/evening.jpg",
    profileConfigPath.."wallpapers/night.jpg"
}
audio = {
    default = 1,
    devices = {
        [1] = { -- these entry numbers reflect the number of the pulse audio sinks the table entries refer to
            volume = 65,
            muted = false,
        },
        [2] = {
            volume = 100,
            muted = false,
        }
    }
}
local autostartapps = {
    "pactl set-sink-volume 1 "..audio.devices[1].volume.."%",
    "pactl set-sink-volume 2 "..audio.devices[2].volume.."%",
    profileConfigPath.."set-output 1",
    "numlockx on",
    "python "..profileConfigPath.."music-server.py"
}
-- Every App has: Name, icon path, and execute path
local applist = {
    [1] = {name = "Atom",icon = profileConfigPath.."newui/atom.png",exec = "/usr/share/atom/atom"},
    [2] = {name = "Steam",icon = profileConfigPath.."newui/steam.png",exec = "/usr/bin/steam"},
    [3] = {name = "Discord",icon = profileConfigPath.."newui/discord.png",exec = "/usr/share/discord/Discord"},
    [4] = {name = "LMMS",icon = profileConfigPath.."newui/lmms.png",exec = "env QT_X11_NO_NATIVE_MENUBAR=1 lmms"},
    [5] = {name = "Blender",icon = profileConfigPath.."newui/blender.png",exec = "/home/legostax/blender-2.78c/blender"},
    [6] = {name = "Dragonframe",icon = profileConfigPath.."newui/df4.png",exec = profileConfigPath.."startdf4"},
    [7] = {name = "Ardour",icon = profileConfigPath.."newui/ardour.png",exec = profileConfigPath.."startardour"},
    [8] = {name = "Natron",icon = profileConfigPath.."newui/natron.png",exec = "/home/legostax/Natron2/Natron"},
    [9] = {name = "Unreal Engine",icon = profileConfigPath.."newui/ue4.png",exec = "/home/legostax/UnrealEngine/Engine/Binaries/Linux/UE4Editor"},
    [10] = {name = "Files",icon = profileConfigPath.."newui/thunar.png",exec = "thunar"}
}
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(profileConfigPath.."themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
}
layouts = awful.layout.layouts
tags = {
    names  = {"CHROME", "PRODUCITIVITY", "SOCIAL", "GAMES"},
    layout = { layouts[1], layouts[1], layouts[1], layouts[1]}
}
for i = 1,#autostartapps do
    awful.util.spawn(autostartapps[i])
end
-- }}}

-- Helper function
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local function notify_me(txt)
    naughty.notify({text = txt})
end

-- Desktop right-click menu
mymainmenu = awful.menu({ items = { { "Hotkeys", function() return false, hotkeys_popup.show_help end, beautiful.awesome_icon },
                                    { "Terminal", terminal },
                                    { "Restart", awesome.restart }
                                  }
                        })

-- Lockdown for going to sleep @ 10:15PM
local btcntdwn = 120
local bedtime = timer({timeout = 60})
local pofftime = timer({timeout = 1})
local wibox_bedtime = wibox({border_width = 0, ontop = true, visible = false, x = 0, y = 0, width = 250, height = 100})
local captiontb = wibox.widget.textbox("Computer shutting down in:")
captiontb.align = "center"
local btcntdwntb = wibox.widget.textbox(tostring(btcntdwn))
btcntdwntb.align = "center"
btcntdwntb.font = "Roboto 50"
wibox_bedtime.widget = wibox.layout.fixed.vertical(captiontb,btcntdwntb)

pofftime:connect_signal("timeout", function()
    if btcntdwn <= 0 then
        awful.util.spawn("systemctl poweroff")
        pofftime:stop()
    else
        btcntdwn = btcntdwn-1
        btcntdwntb.text = tostring(btcntdwn)
    end
end)

bedtime:connect_signal("timeout", function()
    local hr = tonumber(os.date("%H"))
    local min = tonumber(os.date("%M"))
    if hr >= 22 or hr <= 4 then
        if min >= 15 and not pofftime.started then
            wibox_bedtime.visible = true
            pofftime:start()
            bedtime:stop()
        end
    end
end)
bedtime:start()

-- Tween.lua testing
local tween = require("tween")

-- TODO: Build function that returns interruptable animation object
-- createAnimObject( object, duration, end_step, function_type )
local function createAnimObject(obj, duration, endstep, functype)
    -- check if animation is running
    if obj.anim then obj:emit_signal("interrupt", obj) end
    -- create timer at 60 fps
    local t = timer({timeout = 0.0167})
    -- determine variable name to animate
    local val = nil
    for k,v in pairs(endstep) do -- only need to iterate once for our purposes
        val = k -- we will only every animate one value per object
        break
    end
    -- create self-destructing animation-stop callback function
    cback = function(obj)
        t:stop()
        obj:disconnect_signal("interrupt", cback)
    end
    -- create tween
    local twob = tween.new(duration, obj, endstep, functype)
    -- create timeout signal
    obj.dt = 0
    t:connect_signal("timeout", function()
        obj.dt = obj.dt + 0.0167
        twob:update(obj.dt)
        obj:emit_signal("widget::redraw_needed")
        if obj[val] == endstep[val] then
            t:stop()
            cback(obj)
            obj.anim = false
        end
    end)
    -- start animation
    obj:connect_signal("interrupt", cback)
    obj.anim = true
    t:start()
end

local twbox = wibox({border_width = 0, ontop = true, visible = false, x = 100, y = 100, width = 27, height = 2, screen = 1, bg = "#00f", fg = "#fff"})
twbox.open = false
local twtimer = timer({timeout = 2})
twtimer:connect_signal("timeout", function()
    if twbox.open then createAnimObject(twbox, 2, {x = 100, width = 27}, "inOutCubic")
    else createAnimObject(twbox, 2, {x = 112, width = 4}, "inOutCubic") end
    twbox.open = not twbox.open
end)
--twtimer:start()

-- Sysmenu
local sysmenu = wibox({border_width = 0, ontop = true, visible = true, x = 1920, y = 890, width = 240, height = 150, screen = 1, bg = "#232729",  fg = "#fefefe"})
sysmenu.open = false

function toggleSysmenu()
    if sysmenu.open then createAnimObject(sysmenu, 4, {x = 1920}, "inOutCubic")
    else createAnimObject(sysmenu, 4, {x = 1680}, "inOutCubic") end
    sysmenu.open = not sysmenu.open
end

-- Create a speakers/headset switch widget
switchphones = wibox.widget.imagebox(profileConfigPath.."newui/headphones.png", false)
switchspeakers = wibox.widget.imagebox(profileConfigPath.."newui/speakers.png", false)
switchspeakers.opacity = 0
local swlay = wibox.layout.stack()
swlay:add(switchphones,switchspeakers)
local swmarg = wibox.container.margin(swlay,8,0,13)

function animateSwitch(spkrtoph)
    if spkrtoph then
        createAnimObject(switchphones, 4, {opacity = 1}, "inOutCubic")
        createAnimObject(switchspeakers, 4, {opacity = 0}, "inOutCubic")
    else
        createAnimObject(switchphones, 4, {opacity = 0}, "inOutCubic")
        createAnimObject(switchspeakers, 4, {opacity = 1}, "inOutCubic")
    end
end

-- Audio output-related stuff
local vslider = wibox.widget.slider()
vslider.bar_shape = gears.shape.rounded_rect
vslider.bar_height = 2
vslider.bar_color = beautiful.border_color
vslider.bar_border_width = 0
vslider.handle_color = beautiful.bg_focus
vslider.handle_shape = gears.shape.circle
vslider.handle_width = 10
vslider.handle_border_color = beautiful.border_color
vslider.handle_border_width = 0
vslider.value = audio.devices[audio.default].volume
vslider.minimum = 1
vslider.maximum = 100
vslider.forced_width = 150
vslider.forced_height = 30
local slmarg = wibox.container.margin(vslider,20,0,10)

function toggleSound()
    if audio.default == 1 then
        audio.default = 2 -- switch to speakers
        animateSwitch(false)
    else
        audio.default = 1 -- switch to headset
        animateSwitch(true)
    end
    awful.util.spawn(profileConfigPath.."set-output "..audio.default)
    vslider.value = audio.devices[audio.default].volume
    myvolume:emit_signal("volumechange")
end

swmarg:connect_signal("button::release",function(_,_,_,b)
    if b == 1 then toggleSound() end
end)

local vtxt = wibox.widget.textbox("<span color='#aaa'>"..audio.devices[audio.default].volume.."%</span>")
local vtxtmarg = wibox.container.margin(vtxt,10,0,10)
local slcont = wibox.layout.fixed.horizontal(slmarg,vtxtmarg,swmarg)

vslider:connect_signal("property::value", function()
    if not audio.devices[audio.default].muted then
        audio.devices[audio.default].volume = vslider.value
        awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ "..audio.devices[audio.default].volume.."%")
    end
    vtxt:emit_signal("volumechange") -- emit signal for volumechange
end)



-- Music player
local msbkimg = wibox.widget.imagebox(profileConfigPath.."newui/musicprevious.png",false)
local msplayimg = wibox.widget.imagebox(profileConfigPath.."newui/musicplay.png",false)
local mspauseimg = wibox.widget.imagebox(profileConfigPath.."newui/musicpause.png",false)
mspauseimg.opacity = 0
local msfdimg = wibox.widget.imagebox(profileConfigPath.."newui/musicnext.png",false)
local msplaypause = wibox.layout.stack()
msplaypause:add(msplayimg,mspauseimg)
local mssongtxt = wibox.widget.textbox("<span color='#aaa'>Nothing is playing.</span>")
mssongtxt.align = "center"
isPlaying = false

function animatePlayPause()
    if isPlaying then
        createAnimObject(msplayimg, 4, {opacity = 0}, "inOutCubic")
        createAnimObject(mspauseimg, 4, {opacity = 1}, "inOutCubic")
    else
        createAnimObject(msplayimg, 4, {opacity = 1}, "inOutCubic")
        createAnimObject(mspauseimg, 4, {opacity = 0}, "inOutCubic")
    end
end


function togglePlayPause()
    isPlaying = not isPlaying
    if isPlaying then -- run play command
        awful.util.spawn("python "..profileConfigPath.."music-client.py play")
    else -- run pause command
        awful.util.spawn("python "..profileConfigPath.."music-client.py pause")
    end
    animatePlayPause()
end

function bkfd_song(gofd)
    if gofd then -- skip forward
        awful.util.spawn("python "..profileConfigPath.."music-client.py next")
    else -- skip backward
        awful.util.spawn("python "..profileConfigPath.."music-client.py back")
    end
    if not isPlaying then
        isPlaying = true
        animatePlayPause()
    end
end

msplaypause:connect_signal("button::release",function(_,_,_,b)
    if b == 1 then togglePlayPause() end
end)

msbkimg:connect_signal("button::release",function(_,_,_,b)
    if b == 1 then bkfd_song(false) end
end)

msfdimg:connect_signal("button::release",function(_,_,_,b)
    if b == 1 then bkfd_song(true) end
end)

mst = timer({timeout = 5})
mst:connect_signal("timeout", function()
    local output = ""
    for line in io.lines(profileConfigPath..".pymusic-song.txt") do
        output = line
    end
    if output:len() > 20 then
        output = output:sub(1,20).."..."
    end
    mssongtxt.markup = "<span color='#aaa'>"..output.."</span>"
end)
mst:start()

local mscont = wibox.layout.fixed.horizontal(wibox.container.margin(msbkimg,50),msplaypause,msfdimg)



systray = wibox.widget.systray()
systray:set_base_size(32)
sysmenu.widget = wibox.layout.fixed.vertical(slcont,mscont,mssongtxt,systray)

-- App list panel
-- Apps from top to bottom: Atom, Steam, Discord, LMMS, Blender, Dragonframe, Ardour, Natron, Unreal Engine, Thunar
appmenu = wibox({border_width = 0, ontop = true, visible = true, type = "splash", x = -250, y = 408, width = 250, height = 632, screen = 1, bg = "#232729ff", fg = "#fefefe"})
amanim = false

local applistdata = {}
for i = 1,#applist do
    local ref = applist[i]
    local ibox = wibox.widget.imagebox(ref.icon, false)
    local tbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>"..ref.name.."</span>"), 5)
    local cont = wibox.container.margin(wibox.layout.fixed.horizontal(ibox,tbox), 5, 0, 5, 5)
    applistdata[i] = wibox.container.background(cont)
    applistdata[i]:connect_signal("button::press", function(_, _, _, b)
        if b == 1 then
            awful.util.spawn(ref.exec)
            appmenu:emit_signal("close-appmenu")
        end
    end)
    applistdata[i]:connect_signal("mouse::enter", function()
        applistdata[i].bg = "#2f3437"
        applistdata[i]:emit_signal("widget::redraw_needed")
    end)
    applistdata[i]:connect_signal("mouse::leave", function()
        applistdata[i].bg = "#232729"
        applistdata[i]:emit_signal("widget::redraw_needed")
    end)
end

local utillist = {
    [1] = {icon = profileConfigPath.."newui/lock2.png",exec = function() awful.util.spawn("dm-tool lock") end},
    [2] = {icon = profileConfigPath.."newui/logout2.png",exec = awesome.quit},
    [3] = {icon = profileConfigPath.."newui/reboot2.png",exec = function() awful.util.spawn("systemctl reboot") end},
    [4] = {icon = profileConfigPath.."newui/poweroff2.png",exec = function() awful.util.spawn("systemctl poweroff") end}
}
local utillistdata = {}
for i = 1, #utillist do
    local ref = utillist[i]
    utillistdata[i] = wibox.container.margin(wibox.widget.imagebox(ref.icon, false), 30, 0, 10)
    utillistdata[i].opacity = 0.5
    utillistdata[i]:connect_signal("button::press", function(_, _, _, b)
        if b == 1 then
            appmenu:emit_signal("close-appmenu")
            ref.exec()
        end
    end)
    utillistdata[i]:connect_signal("mouse::enter", function()
        createAnimObject(utillistdata[i], 1, {opacity = 0.75}, "inOutCubic")
    end)
    utillistdata[i]:connect_signal("mouse::leave", function()
        createAnimObject(utillistdata[i], 1, {opacity = 0.5}, "inOutCubic")
    end)
end
applistdata[#applistdata + 1] = wibox.layout.fixed.horizontal(unpack(utillistdata))
local amlayout = wibox.layout.fixed.vertical(unpack(applistdata))
appmenu.widget = amlayout

-- Launcher button
launcherimg = wibox.widget.imagebox(profileConfigPath.."newui/applauncher.png",false)
launcherimg_open = wibox.widget.imagebox(profileConfigPath.."newui/applauncher_open.png",false)
launcherimg_open.opacity = 0
launchermargin = wibox.container.margin(launcherimg,8,8,8)
launcherOpen = false

function toggleLauncherImg()
    launcherOpen = not launcherOpen
    if launcherOpen then
        createAnimObject(appmenu, 3, {x = 0}, "inOutCubic")
        createAnimObject(launcherimg, 3, {opacity = 0}, "inOutCubic")
        createAnimObject(launcherimg_open, 3, {opacity = 1}, "inOutCubic")
    else
        createAnimObject(appmenu, 3, {x = -250}, "inOutCubic")
        createAnimObject(launcherimg, 3, {opacity = 1}, "inOutCubic")
        createAnimObject(launcherimg_open, 3, {opacity = 0}, "inOutCubic")
    end
end
launchermargin:connect_signal("button::press", function(_,_,_,b)
    if b == 1 then toggleLauncherImg() end
end)
appmenu:connect_signal("close-appmenu",function()
    toggleLauncherImg()
end)


-- CHROME tag
mychrometag = wibox.widget.imagebox(profileConfigPath.."newui/chrometag.png",false)
chromemargin = wibox.container.margin(mychrometag,5,5,8,0)
chromemargin:connect_signal("button::press", function(_,_,_,b)
    if b == 1 then awful.screen.focused().tags[1]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- PRODUCTIVITY tag
myprodtag = wibox.widget.imagebox(profileConfigPath.."newui/terminaltag.png",false)
prodmargin = wibox.container.margin(myprodtag,5,5,8,0)
prodmargin:connect_signal("button::press", function(_,_,_,b)
    if b == 1 then awful.screen.focused().tags[2]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- SOCIAL tag
mysocialtag = wibox.widget.imagebox(profileConfigPath.."newui/socialtag.png",false)
socialmargin = wibox.container.margin(mysocialtag,5,5,8,0)
socialmargin:connect_signal("button::press", function(_,_,_,b)
    if b == 1 then awful.screen.focused().tags[3]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- GAMES tag
mygametag = wibox.widget.imagebox(profileConfigPath.."newui/gamestag.png",false)
gamemargin = wibox.container.margin(mygametag,5,5,10,0)
gamemargin:connect_signal("button::press", function(_,_,_,b)
    if b == 1 then awful.screen.focused().tags[4]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)


-- Tag underline
tagline = wibox({border_width = 0, ontop = true, visible = true, type = "splash", x = 1723, y = 1078, width = 34, height = 2, screen = 1, bg = "#4082f7", fg = "#fefefe"})
tloldtag = 1
tlanim = false
tagline:connect_signal("button::press", function(_,_,_,b)
    if b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- Animate tagline back and forth between icons
function animateTagline(newtagpos)
    createAnimObject(tagline, 1.5, {x = newtagpos}, "inOutCubic")
end

-- X1: 1723, X2: 1757, X3: 1791, X4: 1827
awful.screen.focused():connect_signal("tag::history::update", function()
    local curclients = awful.screen.focused().selected_tag:clients()
    local val = true
    for _, c in ipairs(curclients) do
        if c.fullscreen then
            val = false
            break
        end
    end
    tagline.visible = val
    if awful.screen.focused().tags[1].selected then
        if tagline.visible then -- if visible, commence animation
            animateTagline(1723)
        else tagline.x = 1723 end
    elseif awful.screen.focused().tags[2].selected then
        if tagline.visible then
            animateTagline(1757)
        else tagline.x = 1757 end
    elseif awful.screen.focused().tags[3].selected then
        if tagline.visible then
            animateTagline(1791)
        else tagline.x = 1791 end
    elseif awful.screen.focused().tags[4].selected then
        if tagline.visible then
            animateTagline(1827)
        else tagline.x = 1827 end
    end
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %H:%M ")


-- Create volume percent textbox
myvolume = wibox.widget.textbox(audio.devices[audio.default].volume.."%")

-- syswidget clickable cont
syscont = wibox.container.margin(mytextclock,10,10)
syscont:connect_signal("button::press",function(_,_,_,b)
    if b == 1 then toggleSysmenu() end
end)
-- tooltip displays date
mytextclock_t = awful.tooltip({
    objects = { syscont },
    timer_function = function()
        return os.date("%b %d, %Y")
    end,
    delay_show = 1
})




-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     --awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function wallpaperChanger(s)
    local hr = tonumber(string.sub(os.date("%X"), 1, 2))
    local min = tonumber(string.sub(os.date("%X"), 3, 4))
    if hr >= 0 and hr <= 4 then --night
        gears.wallpaper.maximized(wallpapers[4], s, true)
    elseif hr >= 5 and hr <= 8 then -- morning
        gears.wallpaper.maximized(wallpapers[1], s, true)
    elseif hr >= 9 and hr <= 15 then -- day
        gears.wallpaper.maximized(wallpapers[2], s, true)
    elseif hr >= 16 and hr <= 18 then -- evening
        gears.wallpaper.maximized(wallpapers[3], s, true)
    elseif hr >= 19 and hr <= 23 then -- night
        gears.wallpaper.maximized(wallpapers[4], s, true)
    end
end

local wlpr_timer = timer({timeout = 60})
wlpr_timer:connect_signal("timeout", function() wallpaperChanger(1) end)
wlpr_timer:start()

-- Tasklist stuffs
local function list_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, ibmm, tb, ibm, const
        if cache then
            ib = cache.ib
            ibmm = cache.ibmm
            tb = cache.tb
            ibm = cache.ibm
            const = cache.const
        else
            ib = wibox.widget.imagebox()
            ib.forced_width = 32
            ib.forced_height = 32
            ibmm = wibox.container.margin(ib, 0, 0, 0, 2)
            tb = wibox.widget.textbox()
            ibm = wibox.container.margin(ibmm, 8, 0, 4, 0)
            const = wibox.container.constraint(ibm, "min", 40)

            ibm:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib  = ib,
                ibmm = ibmm,
                tb  = tb,
                ibm = ibm,
                const = const,
            }
        end

        local text, bg, bg_image, icon, args = label(o, tb)

        ibmm.color = bg
        if icon then ib:set_image(icon)
        else ibm:set_margins(0) end

        w:add(const)
   end
   naughty.notify({text = "C", timeout = 0.01}) -- prevent drawing glitches when ForceFullCompositionPipeline = true in nvidia-settings
end

-- Wibar transparent/opaque function
local function checkWibar(obj, s)
    --notify_me("checkWibar")
    local curclients = s.clients
    obj.bg = "#00000088"
    for _, c in pairs(curclients) do
        --notify_me("iterating")
        if c.maximized then
            obj.bg = "#000"
            break
        end
    end
    obj:emit_signal("widget::redraw_needed")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", wallpaperChanger)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    wallpaperChanger(s)

    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, nil, list_update, wibox.layout.fixed.horizontal())

    -- Create the wibox #31373a00
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 40, bg = "#00000088" })
    -- Transparent on no maximized clients; opaque on 1 or more maximized clients
    --checkWibar(s.mywibox, s)
    s:connect_signal("tag::history::update", function() checkWibar(s.mywibox, s) end)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    launcherimg,
                    launcherimg_open,
                    layout = wibox.layout.stack
                },
                layout = launchermargin
            },
            --s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            {
                mychrometag,
                layout = chromemargin
            },
            {
                myprodtag,
                layout = prodmargin
            },
            {
                mysocialtag,
                layout = socialmargin
            },
            {
                mygametag,
                layout = gamemargin
            },
            syscont
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({modkey}, "l", function() awful.util.spawn("dm-tool lock") end, {description = "lockscreen", group = "awesome"}),
    awful.key({}, "Print", function() awful.util.spawn_with_shell("scrot -e 'mv $f ~/Screenshots/'") end, {description = "take screenshot", group = "awesome"}),
    awful.key({"Control", modkey}, "Delete", function() awful.util.spawn("xfce4-taskmanager") end, {description = "open task manager", group = "awesome"}),
    awful.key({}, "#123", function()
        if audio.devices[audio.default].volume < 100 then
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%")
            audio.devices[audio.default].volume = audio.devices[audio.default].volume+1
            audio.devices[audio.default].muted = false
            vslider.value = audio.devices[audio.default].volume
            myvolume:emit_signal("volumechange")
        end
    end, {description = "+1% volume", group = "awesome"}),
    awful.key({}, "#122", function()
        if audio.devices[audio.default].volume > 0 then
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%")
            audio.devices[audio.default].volume = audio.devices[audio.default].volume-1
            vslider.value = audio.devices[audio.default].volume
            myvolume:emit_signal("volumechange")
        end
    end, {description = "-1% volume", group = "awesome"}),
    awful.key({}, "#121", function()
        if audio.devices[audio.default].muted then
            audio.devices[audio.default].muted = false
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ "..audio.devices[audio.default].volume.."%")
            vslider.value = audio.devices[audio.default].volume
            myvolume:emit_signal("volumechange")
        else
            audio.devices[audio.default].muted = true
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ 0")
            vslider.value = 0
            myvolume:emit_signal("volumechange")
        end
    end, {description = "toggle volume mute", group = "awesome"}),
    awful.key({}, "#148", function() awful.util.spawn("gnome-calculator") end, {description = "open calculator", group = "awesome"}),
    awful.key({}, "#150", function() awful.util.spawn("dm-tool lock") awful.util.spawn("systemctl suspend") end, {description = "sleep/suspend", group = "awesome"}),
    awful.key({modkey, "Control"}, "p", togglePlayPause, {description = "Play/Pause music", group = "music"}),
    awful.key({modkey, "Control"}, "Left", function() bkfd_song(false) end, {description = "Back 1 song", group = "music"}),
    awful.key({modkey, "Control"}, "Right", function() bkfd_song(true) end, {description = "Forward 1 song", group = "music"}),
    awful.key({modkey}, "e", toggleLauncherImg, {description = "open app menu", group = "awesome"}),
    awful.key({modkey}, "w", toggleSysmenu, {description = "open sys menu", group = "awesome"}),

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, "Shift" }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "q", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Standard program
    awful.key({modkey}, "t", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function() awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    -- App opening shortcuts
    awful.key({ modkey, "Shift" }, "m", function() awful.util.spawn("thunar") end, {description = "open file manager", group = "awesome"}),
    -- TAG-BASED KEYBINDINGS
    -- Open Chrome on CHROME tag
    awful.key({ modkey }, "n", function()
        local t = awful.screen.focused().selected_tag
        if t.index == 1 then awful.util.spawn("google-chrome")
        elseif t.index == 3 then awful.util.spawn("/usr/share/discord/Discord")
        elseif t.index == 4 then awful.util.spawn("/usr/bin/steam") end
    end, {description = "open default tag program", group = "tag"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey}, "F4",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- CHROME tag
    {rule = {class = "Google-chrome"}, properties = {screen = 1, tag = awful.screen.focused().tags[1], maximized = true}},
    {rule = {class = "Firefox"}, properties = {screen = 1, tag = awful.screen.focused().tags[1]}},
    -- PRODUCTIVITY tag
    {rule = {class = "Atom"}, properties = {screen = 1, tag = awful.screen.focused().tags[2], maximized = true}},
    {rule = {class = "Lmms"}, properties = {screen = 1, tag = awful.screen.focused().tags[2], maximized = true}},
    {rule = {class = "Blender"}, properties = {screen = 1, tag = awful.screen.focused().tags[2], maximized = true}},
    {rule = {class = "Dragonframe"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Ardour-5.8.0"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Natron"}, properties = {screen = 1, tag = awful.screen.focused().tags[2], maximized = true}},
    {rule = {class = "UE4Editor"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    -- SOCIAL tag
    {rule = {class = "discord"}, properties = {screen = 1, tag = awful.screen.focused().tags[3], maximized = true}},
    {rule = {instance = "crx_nckgahadagoaajjgafhacjanaoiihapd", class = "Google-chrome"}, properties = {screen = 1, tag = awful.screen.focused().tags[3], maximized = false}},
    -- GAMES tag
    {rule = {class = "Steam"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "steam"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}}, -- Big Picture mode
    {rule = {name = "SUPERHOT"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "Terraria.bin.x86"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "hl2_linux", name = "Garry's Mod - OpenGL"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "hl2_linux", name = "Portal - OpenGL"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "portal2_linux"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},
    {rule = {class = "RocketLeague"}, properties = {screen = 1, tag = awful.screen.focused().tags[4]}},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

}
-- }}}

-- {{{ Signals
vtxt:connect_signal("volumechange", function()
    if audio.devices[audio.default].muted then
        vtxt.markup = "<span color='#aaa'>0%</span>"
    else
        vtxt.markup = "<span color='#aaa'>"..audio.devices[audio.default].volume.."%</span>"
    end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
    checkWibar(c.screen.mywibox, c.screen)
end)

client.connect_signal("unmanage", function (c)
    if awful.rules.match(c, {class = "Chrauncher"}) and launcherOpen then
        toggleLauncherImg()
    end

    local curclients = awful.screen.focused().selected_tag:clients()
    local val = true
    for _, c in ipairs(curclients) do
        if c.fullscreen then
            val = false
            break
        end
    end
    tagline.visible = val
    checkWibar(c.screen.mywibox, c.screen)
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        tagline.visible = false
    else
        tagline.visible = true
    end
end)

client.connect_signal("property::maximized", function(c) checkWibar(c.screen.mywibox, c.screen) end)
client.connect_signal("property::minimized", function(c) checkWibar(c.screen.mywibox, c.screen) end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    if not awful.rules.match(c, {class = "Chrauncher"}) then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
        )
        titlebaricon = awful.titlebar.widget.iconwidget(c)
        titlebaricon.forced_height = 20
        titlebaricon.forced_width = 20

        local maximized = wibox.widget.imagebox(profileConfigPath.."themes/default/titlebar/maximized_focus_active3.png",false)
        c:connect_signal("focus",function()
            maximized.image = "themes/default/titlebar/maximized_focus_active3.png"
        end)
        c:connect_signal("unfocus",function()
            maximized.image = "themes/default/titlebar/normal.png"
        end)
        c:connect_signal("mouse::enter",function()
            maximized.image = "themes/default/titlebar/maximized_focus_active2.png"
        end)
        c:connect_signal("mouse::leave",function()
            maximized.image = "themes/default/titlebar/maximized_focus_active3.png"
        end)


        titlebartext = wibox.container.margin(awful.titlebar.widget.titlewidget(c),5)
        titlebartext.align = "left"
        awful.titlebar(c, { size = 28, bg_focus = beautiful.window_bg_focus, bg_normal = beautiful.window_bg_normal, fg_focus = beautiful.window_fg_focus, fg_normal = beautiful.window_fg_normal }) : setup {
            { -- Left
                {
                    titlebaricon,
                    layout = wibox.container.margin(titlebaricon,3,0,3)
                },
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    titlebartext,
                    layout = wibox.container.margin(titlebartext,-1)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.minimizebutton(c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.closebutton(c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }
    end
end)
