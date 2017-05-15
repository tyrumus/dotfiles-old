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
-- Chrome OS widgets
--local syswidget = require("syswidget")

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
profileConfigPath = "/home/legostax/.config/awesome/"
beautiful.init(profileConfigPath.."themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
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
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
layouts = awful.layout.layouts
audio = {
    default = 1,
    devices = {
        [1] = {
            volume = 65,
            muted = false,
        },
        [2] = {
            volume = 100,
            muted = false,
        }
    }
}
tags = {
    names  = {"CHROME", "PRODUCITIVITY", "SOCIAL", "GAMES"},
    layout = { layouts[1], layouts[1], layouts[1], layouts[1]}
}
autostartapps = {
    profileConfigPath.."changedw",
    "pactl set-sink-volume 1 "..audio.devices[1].volume.."%",
    "pactl set-sink-volume 2 "..audio.devices[2].volume.."%",
    profileConfigPath.."set-output 1",
    "numlockx on",
    "python "..profileConfigPath.."music-server.py"
}
for i = 1,#autostartapps do
    awful.util.spawn(autostartapps[i])
end
-- }}}

-- {{{ Helper functions
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
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu

mymainmenu = awful.menu({ items = { { "Hotkeys", function() return false, hotkeys_popup.show_help end, beautiful.awesome_icon },
                                    { "Terminal", terminal },
                                    { "Restart", awesome.restart }
                                  }
                        })

-- Custom update_function for tasklist
function custom_update(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    naughty.notify({text = "running custom_update"})
    w:set_max_widget_size(200)
    --[[local lay = wibox.layout.fixed.horizontal()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l
        if cache then
            ib = cache.ib
            --tb = cache.tb
            bgb = cache.bgb
            --tbm = cache.tbm
            ibm = cache.ibm
        else
            ib = wibox.widget.imagebox()
            --tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            --tbm = wibox.container.margin(tb, dpi(4), dpi(4))
            ibm = wibox.container.margin(ib, dpi(4))
            l = wibox.layout.fixed.vertical()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)
            --l:add(tbm)

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib  = ib,
                --tb  = tb,
                bgb = bgb,
                --tbm = tbm,
                ibm = ibm,
            }
        end
        local text, bg, bg_image, icon, args = label(o, tb)
        args = args or {}

        -- The text might be invalid, so use pcall.
        if text == nil or text == "" then
            tbm:set_margins(0)
        else
            if not tb:set_markup_silently(text) then
                tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            -- TODO: Why does this pass nil as an argument?
            bg_image = bg_image(tb,o,nil,objects,i)
        end
        bgb:set_bgimage(bg_image)
        if icon then
            ib:set_image(icon)
        else
            ibm:set_margins(0)
        end

        bgb.shape              = args.shape
        bgb.shape_border_width = args.shape_border_width
        bgb.shape_border_color = args.shape_border_color

        lay:add(bgb)
        --w:add(bgb)

        bgb.bg = "#00f"
        bgb.fg = "#00f"
        tbm.color = "#f00"
        ibm.color = "#0f0"
        ib.resize = false
        ib.forced_width = 20
        ib.forced_height = 20
   end]]--
end


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

-- Sysmenu
sysmenu = wibox({border_width = 0, ontop = true, visible = true, x = 1920, y = 890, width = 240, height = 150, screen = 1, bg = "#232729",  fg = "#fefefe"})
smopen = false
smanim = false

function toggleSysmenu()
    if smanim then sysmenu:emit_signal("sm-interrupt") end
    local t = timer({timeout = 0.005})
    smcallback = function()
        t:stop()
        sysmenu:disconnect_signal("sm-interrupt",smcallback)
    end
    smopen = not smopen
    if smopen then --opening anim
        t:connect_signal("timeout",function()
            sysmenu.x = sysmenu.x - 10
            sysmenu:emit_signal("widget::redraw_needed")
            if sysmenu.x == 1680 then
                t:stop()
                sysmenu.x = 1680
                sysmenu:disconnect_signal("sm-interrupt",smcallback)
                smanim = false
            end
        end)
    else --closing anim
        t:connect_signal("timeout",function()
            sysmenu.x = sysmenu.x + 10
            sysmenu:emit_signal("widget::redraw_needed")
            if sysmenu.x == 1920 then
                t:stop()
                sysmenu.x = 1920
                sysmenu:disconnect_signal("sm-interrupt",smcallback)
                smanim = false
            end
        end)
    end
    smanim = true
    sysmenu:connect_signal("sm-interrupt",smcallback)
    t:start()
end

-- Create a speakers/headset switch widget
switchphones = wibox.widget.imagebox(profileConfigPath.."newui/headphones.png", false)
switchspeakers = wibox.widget.imagebox(profileConfigPath.."newui/speakers.png", false)
switchspeakers.opacity = 0
local swlay = wibox.layout.stack()
swlay:add(switchphones,switchspeakers)
local swmarg = wibox.container.margin(swlay,8,0,13)

-- positive factor gives phones to speakers, negative is opposite
function animateSwitch(spkrtoph, factor, delay)
    local f = 0.1
    local t = timer({timeout = 0.01})

    if spkrtoph then
        t:connect_signal("timeout", function()
            switchphones.opacity = switchphones.opacity+0.1
            switchspeakers.opacity = switchspeakers.opacity-0.1
            switchphones:emit_signal("widget::redraw_needed")
            switchspeakers:emit_signal("widget::redraw_needed")
            if switchspeakers.opacity <= 0 then t:stop() end
        end)
    else
        t:connect_signal("timeout", function()
            switchphones.opacity = switchphones.opacity-0.1
            switchspeakers.opacity = switchspeakers.opacity+0.1
            switchphones:emit_signal("widget::redraw_needed")
            switchspeakers:emit_signal("widget::redraw_needed")
            if switchspeakers.opacity >= 1 then t:stop() end
        end)
    end
    t:start()
end

--[[{
    {
        switchphones,
        switchspeakers,
        layout = wibox.layout.stack
    },
    layout = wibox.container.margin(switchphones,0,0,10)
},]]


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
        audio.default = 2
        -- switch to speakers
        animateSwitch(false)
    else
        audio.default = 1
        -- switch to headset
        animateSwitch(true)
    end
    awful.util.spawn(profileConfigPath.."set-output "..audio.default)
    vslider.value = audio.devices[audio.default].volume
    myvolume:emit_signal("volumechange")
end

swmarg:connect_signal("button::release",function(mod,x,y,b)
    if b == 1 then toggleSound() end
end)

local vtxt = wibox.widget.textbox("<span color='#aaa'>"..audio.devices[audio.default].volume.."%</span>")
local vtxtmarg = wibox.container.margin(vtxt,10,0,10)
local slcont = wibox.layout.fixed.horizontal(slmarg,vtxtmarg,swmarg)

vslider:connect_signal("property::value", function()
    --emit signal for volumechange
    if not audio.devices[audio.default].muted then
        audio.devices[audio.default].volume = vslider.value
        awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ "..audio.devices[audio.default].volume.."%")
    end
    vtxt:emit_signal("volumechange")
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
ppanim = false

function animatePlayPause()
    if ppanim then mspauseimg:emit_signal("pp-interrupt") end
    local t = timer({timeout = 0.01})
    amcallback = function()
        t:stop()
        mspauseimg:disconnect_signal("pp-interrupt",amcallback)
    end
    if isPlaying then
        t:connect_signal("timeout", function()
            msplayimg.opacity = msplayimg.opacity-0.1
            mspauseimg.opacity = mspauseimg.opacity+0.1
            msplayimg:emit_signal("widget::redraw_needed")
            mspauseimg:emit_signal("widget::redraw_needed")
            if msplayimg.opacity <= 0 then
                t:stop()
                msplayimg.opacity = 0
                mspauseimg.opacity = 1
                mspauseimg:disconnect_signal("pp-interrupt",amcallback)
                ppanim = false
            end
        end)
    else
        t:connect_signal("timeout", function()
            msplayimg.opacity = msplayimg.opacity+0.1
            mspauseimg.opacity = mspauseimg.opacity-0.1
            msplayimg:emit_signal("widget::redraw_needed")
            mspauseimg:emit_signal("widget::redraw_needed")
            if msplayimg.opacity >= 1 then
                t:stop()
                msplayimg.opacity = 1
                mspauseimg.opacity = 0
                mspauseimg:disconnect_signal("pp-interrupt",amcallback)
                ppanim = false
            end
        end)
    end
    mspauseimg:connect_signal("pp-interrupt", amcallback)
    ppanim = true
    t:start()
end


function togglePlayPause()
    isPlaying = not isPlaying
    if isPlaying then
        -- run play command
        awful.util.spawn("python "..profileConfigPath.."music-client.py play")
    else
        -- run pause command
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

msplaypause:connect_signal("button::release",function(mod,x,y,b)
    if b == 1 then togglePlayPause() end
end)

msbkimg:connect_signal("button::release",function(mod,x,y,b)
    if b == 1 then bkfd_song(false) end
end)

msfdimg:connect_signal("button::release",function(mod,x,y,b)
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
-- Apps from top to bottom: Atom, Steam, Discord, LMMS, Blender, Dragonframe, Ardour, Natron, Thunar
appmenu = wibox({border_width = 0, ontop = true, visible = true, type = "splash", x = -250, y = 466, width = 250, height = 574, screen = 1, bg = "#232729ff", fg = "#fefefe"})
amanim = false
local apptim = timer({timeout = 5})
apptim:connect_signal("timeout", function()
    naughty.notify({text = "ran"})
    appmenu.bg = "#23272900"
    appmenu:emit_signal("widget::redraw_needed")
    apptim:stop()
end)
apptim:start()

-- Atom Text Editor
atomimgbox = wibox.widget.imagebox(profileConfigPath.."newui/atom.png",false)
atomtxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Atom</span>"),5)
atomcont = wibox.container.margin(wibox.layout.fixed.horizontal(atomimgbox,atomtxtbox),5,0,5,5)
atomcontbg = wibox.container.background(atomcont)
atomcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("/usr/share/atom/atom")
        appmenu:emit_signal("close-appmenu")
    end
end)
atomcont:connect_signal("mouse::enter",function()
    atomcontbg.bg = "#2f3437"
    atomcont:emit_signal("widget::redraw_needed")
end)
atomcont:connect_signal("mouse::leave",function()
    atomcontbg.bg = "#232729"
    atomcontbg:emit_signal("widget::redraw_needed")
end)


-- Steam
steamimgbox = wibox.widget.imagebox(profileConfigPath.."newui/steam.png",false)
steamtxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Steam</span>"),5)
steamcont = wibox.container.margin(wibox.layout.fixed.horizontal(steamimgbox,steamtxtbox),5,0,5,5)
steamcontbg = wibox.container.background(steamcont)
steamcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("/usr/bin/steam")
        appmenu:emit_signal("close-appmenu")
    end
end)
steamcont:connect_signal("mouse::enter",function()
    steamcontbg.bg = "#2f3437"
    steamcontbg:emit_signal("widget::redraw_needed")
end)
steamcont:connect_signal("mouse::leave",function()
    steamcontbg.bg = "#232729"
    steamcontbg:emit_signal("widget::redraw_needed")
end)

-- Discord
discimgbox = wibox.widget.imagebox(profileConfigPath.."newui/discord.png",false)
disctxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Discord</span>"),5)
disccont = wibox.container.margin(wibox.layout.fixed.horizontal(discimgbox,disctxtbox),5,0,5,5)
disccontbg = wibox.container.background(disccont)
disccont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("/usr/share/discord/Discord")
        appmenu:emit_signal("close-appmenu")
    end
end)
disccont:connect_signal("mouse::enter",function()
    disccontbg.bg = "#2f3437"
    disccontbg:emit_signal("widget::redraw_needed")
end)
disccont:connect_signal("mouse::leave",function()
    disccontbg.bg = "#232729"
    disccontbg:emit_signal("widget::redraw_needed")
end)


-- LMMS
lmmsimgbox = wibox.widget.imagebox(profileConfigPath.."newui/lmms.png",false)
lmmstxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>LMMS</span>"),5)
lmmscont = wibox.container.margin(wibox.layout.fixed.horizontal(lmmsimgbox,lmmstxtbox),5,0,5,5)
lmmscontbg = wibox.container.background(lmmscont)
lmmscont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("env QT_X11_NO_NATIVE_MENUBAR=1 lmms")
        appmenu:emit_signal("close-appmenu")
    end
end)
lmmscont:connect_signal("mouse::enter",function()
    lmmscontbg.bg = "#2f3437"
    lmmscontbg:emit_signal("widget::redraw_needed")
end)
lmmscont:connect_signal("mouse::leave",function()
    lmmscontbg.bg = "#232729"
    lmmscontbg:emit_signal("widget::redraw_needed")
end)

-- Blender
blendimgbox = wibox.widget.imagebox(profileConfigPath.."newui/blender.png",false)
blendtxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Blender</span>"),5)
blendcont = wibox.container.margin(wibox.layout.fixed.horizontal(blendimgbox,blendtxtbox),5,0,5,5)
blendcontbg = wibox.container.background(blendcont)
blendcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("/home/legostax/blender-2.78c/blender")
        appmenu:emit_signal("close-appmenu")
    end
end)
blendcont:connect_signal("mouse::enter",function()
    blendcontbg.bg = "#2f3437"
    blendcont:emit_signal("widget::redraw_needed")
end)
blendcont:connect_signal("mouse::leave",function()
    blendcontbg.bg = "#232729"
    blendcontbg:emit_signal("widget::redraw_needed")
end)

-- Dragonframe
dfimgbox = wibox.widget.imagebox(profileConfigPath.."newui/df4.png",false)
dftxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Dragonframe</span>"),5)
dfcont = wibox.container.margin(wibox.layout.fixed.horizontal(dfimgbox,dftxtbox),5,0,5,5)
dfcontbg = wibox.container.background(dfcont)
dfcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn(profileConfigPath.."startdf4")
        appmenu:emit_signal("close-appmenu")
    end
end)
dfcont:connect_signal("mouse::enter",function()
    dfcontbg.bg = "#2f3437"
    dfcontbg:emit_signal("widget::redraw_needed")
end)
dfcont:connect_signal("mouse::leave",function()
    dfcontbg.bg = "#232729"
    dfcontbg:emit_signal("widget::redraw_needed")
end)

-- Ardour
ardourimgbox = wibox.widget.imagebox(profileConfigPath.."newui/ardour.png",false)
ardourtxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Ardour</span>"),5)
ardourcont = wibox.container.margin(wibox.layout.fixed.horizontal(ardourimgbox,ardourtxtbox),5,0,5,5)
ardourcontbg = wibox.container.background(ardourcont)
ardourcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn(profileConfigPath.."startardour")
        appmenu:emit_signal("close-appmenu")
    end
end)
ardourcont:connect_signal("mouse::enter",function()
    ardourcontbg.bg = "#2f3437"
    ardourcontbg:emit_signal("widget::redraw_needed")
end)
ardourcont:connect_signal("mouse::leave",function()
    ardourcontbg.bg = "#232729"
    ardourcontbg:emit_signal("widget::redraw_needed")
end)

-- Natron
natronimgbox = wibox.widget.imagebox(profileConfigPath.."newui/natron.png",false)
natrontxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Natron</span>"),5)
natroncont = wibox.container.margin(wibox.layout.fixed.horizontal(natronimgbox,natrontxtbox),5,0,5,5)
natroncontbg = wibox.container.background(natroncont)
natroncont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("/home/legostax/Natron2/Natron")
        appmenu:emit_signal("close-appmenu")
    end
end)
natroncont:connect_signal("mouse::enter",function()
    natroncontbg.bg = "#2f3437"
    natroncont:emit_signal("widget::redraw_needed")
end)
natroncont:connect_signal("mouse::leave",function()
    natroncontbg.bg = "#232729"
    natroncontbg:emit_signal("widget::redraw_needed")
end)

-- Thunar/File Manager
fmimgbox = wibox.widget.imagebox(profileConfigPath.."newui/thunar.png",false)
fmtxtbox = wibox.container.margin(wibox.widget.textbox("<span color='#aaa'>Files</span>"),5)
fmcont = wibox.container.margin(wibox.layout.fixed.horizontal(fmimgbox,fmtxtbox),5,0,5,5)
fmcontbg = wibox.container.background(fmcont)
fmcont:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        awful.util.spawn("thunar")
        appmenu:emit_signal("close-appmenu")
    end
end)
fmcont:connect_signal("mouse::enter",function()
    fmcontbg.bg = "#2f3437"
    fmcontbg:emit_signal("widget::redraw_needed")
end)
fmcont:connect_signal("mouse::leave",function()
    fmcontbg.bg = "#232729"
    fmcontbg:emit_signal("widget::redraw_needed")
end)



-- Lock, Logout, Reboot, Poweroff
lockimgbox = wibox.container.margin(wibox.widget.imagebox(profileConfigPath.."newui/lock2.png",false),30,0,10)
lockimgbox.opacity = 0.5
lockimgbox:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then
        appmenu:emit_signal("close-appmenu")
        awful.util.spawn("dm-tool lock")
    end
end)
lockimgbox:connect_signal("mouse::enter",function()
    lockimgbox.opacity = 0.75
    lockimgbox:emit_signal("widget::redraw_needed")
end)
lockimgbox:connect_signal("mouse::leave",function()
    lockimgbox.opacity = 0.5
    lockimgbox:emit_signal("widget::redraw_needed")
end)
logoutimgbox = wibox.container.margin(wibox.widget.imagebox(profileConfigPath.."newui/logout2.png",false),30,0,10)
logoutimgbox.opacity = 0.5
logoutimgbox:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then awesome.quit() end
end)
logoutimgbox:connect_signal("mouse::enter",function()
    logoutimgbox.opacity = 0.75
    logoutimgbox:emit_signal("widget::redraw_needed")
end)
logoutimgbox:connect_signal("mouse::leave",function()
    logoutimgbox.opacity = 0.5
    logoutimgbox:emit_signal("widget::redraw_needed")
end)
rebootimgbox = wibox.container.margin(wibox.widget.imagebox(profileConfigPath.."newui/reboot2.png",false),30,0,10)
rebootimgbox.opacity = 0.5
rebootimgbox:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then awful.util.spawn("systemctl reboot") end
end)
rebootimgbox:connect_signal("mouse::enter",function()
    rebootimgbox.opacity = 0.75
    rebootimgbox:emit_signal("widget::redraw_needed")
end)
rebootimgbox:connect_signal("mouse::leave",function()
    rebootimgbox.opacity = 0.5
    rebootimgbox:emit_signal("widget::redraw_needed")
end)
poffimgbox = wibox.container.margin(wibox.widget.imagebox(profileConfigPath.."newui/poweroff2.png",false),30,0,10)
poffimgbox.opacity = 0.5
poffimgbox:connect_signal("button::press",function(mod,x,y,b)
    if b == 1 then awful.util.spawn("systemctl poweroff") end
end)
poffimgbox:connect_signal("mouse::enter",function()
    poffimgbox.opacity = 0.75
    poffimgbox:emit_signal("widget::redraw_needed")
end)
poffimgbox:connect_signal("mouse::leave",function()
    poffimgbox.opacity = 0.5
    poffimgbox:emit_signal("widget::redraw_needed")
end)
utilcont = wibox.layout.fixed.horizontal(lockimgbox,logoutimgbox,rebootimgbox,poffimgbox)






-- App list setup

local amlayout = wibox.layout.fixed.vertical(atomcontbg,steamcontbg,disccontbg,lmmscontbg,blendcontbg,dfcontbg,ardourcontbg,natroncontbg,fmcontbg,utilcont)
appmenu.widget = amlayout
--[[appmenu:setup({
    layout = wibox.layout.fixed.vertical,
    {
        atomimgbox,
        steamimgbox,
        discimgbox,
        dfimgbox
    }
})]]--




-- debug
debugtxt = wibox.widget.textbox("Iamdebug")
--debugtxt.text = "derp"

-- Launcher button
launcherimg = wibox.widget.imagebox(profileConfigPath.."newui/applauncher.png",false)
launcherimg_open = wibox.widget.imagebox(profileConfigPath.."newui/applauncher_open.png",false)
launcherimg_open.opacity = 0
launchermargin = wibox.container.margin(launcherimg,8,8,8)
launcherOpen = false
lnanim = false

function animateLauncher()
    if amanim then appmenu:emit_signal("interrupt") end
    local t = timer({timeout = 0.005})
    amcallback = function()
        t:stop()
        appmenu:disconnect_signal("interrupt",amcallback)
    end
    if launcherOpen then
        t:connect_signal("timeout", function()
            appmenu.x = appmenu.x+10
            appmenu:emit_signal("widget::redraw_needed")
            if appmenu.x == 0 then
                t:stop()
                appmenu:disconnect_signal("interrupt",amcallback)
                amanim = false
            end
        end)
    else
        t:connect_signal("timeout", function()
            appmenu.x = appmenu.x-10
            appmenu:emit_signal("widget::redraw_needed")
            if appmenu.x == -250 then
                t:stop()
                appmenu:disconnect_signal("interrupt",amcallback)
                amanim = false
            end
        end)
    end
    appmenu:connect_signal("interrupt", amcallback)
    amanim = true
    t:start()
end

function animateLauncherImg()
    if lnanim then launcherimg:emit_signal("ln-interrupt") end
    local t = timer({timeout = 0.01})
    lncallback = function()
        t:stop()
        launcherimg:disconnect_signal("ln-interrupt",lncallback)
    end
    if launcherOpen then
        t:connect_signal("timeout", function()
            launcherimg.opacity = launcherimg.opacity-0.1
            launcherimg_open.opacity = launcherimg_open.opacity+0.1
            launcherimg:emit_signal("widget::redraw_needed")
            launcherimg_open:emit_signal("widget::redraw_needed")
            if launcherimg_open.opacity >= 1 then
                t:stop()
                launcherimg:disconnect_signal("ln-interrupt",lncallback)
                lnanim = false
            end
        end)
    else
        t:connect_signal("timeout", function()
            launcherimg.opacity = launcherimg.opacity+0.1
            launcherimg_open.opacity = launcherimg_open.opacity-0.1
            launcherimg:emit_signal("widget::redraw_needed")
            launcherimg_open:emit_signal("widget::redraw_needed")
            if launcherimg_open.opacity <= 0 then
                t:stop()
                launcherimg:disconnect_signal("ln-interrupt",lncallback)
                lnanim = false
            end
        end)
    end
    launcherimg:connect_signal("ln-interrupt",lncallback)
    lnanim = true
    t:start()
end


function toggleLauncherImg()
    --[[if launcherOpen then -- close launcher
        launcherimg.image = profileConfigPath.."newui/applauncher.png"
        -- close wibox
    else -- open launcher
        launcherimg.image = profileConfigPath.."newui/applauncher_open.png"
        -- open wibox
    end]]--
    launcherOpen = not launcherOpen
    animateLauncherImg()
    animateLauncher()
end
launchermargin:connect_signal("button::press", function(mod,x,y,b)
    if b == 1 then toggleLauncherImg() end
end)
appmenu:connect_signal("close-appmenu",function()
    toggleLauncherImg()
end)


-- CHROME tag
mychrometag = wibox.widget.imagebox(profileConfigPath.."newui/chrometag.png",false)
chromemargin = wibox.container.margin(mychrometag,5,5,8,0)
chromemargin:connect_signal("button::press", function(mod,x,y,b)
    if b == 1 then awful.screen.focused().tags[1]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- PRODUCTIVITY tag
myprodtag = wibox.widget.imagebox(profileConfigPath.."newui/terminaltag.png",false)
prodmargin = wibox.container.margin(myprodtag,5,5,8,0)
prodmargin:connect_signal("button::press", function(mod,x,y,b)
    if b == 1 then awful.screen.focused().tags[2]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- SOCIAL tag
mysocialtag = wibox.widget.imagebox(profileConfigPath.."newui/socialtag.png",false)
socialmargin = wibox.container.margin(mysocialtag,5,5,8,0)
socialmargin:connect_signal("button::press", function(mod,x,y,b)
    if b == 1 then awful.screen.focused().tags[3]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

-- GAMES tag
mygametag = wibox.widget.imagebox(profileConfigPath.."newui/gamestag.png",false)
gamemargin = wibox.container.margin(mygametag,5,5,10,0)
gamemargin:connect_signal("button::press", function(mod,x,y,b)
    if b == 1 then awful.screen.focused().tags[4]:view_only()
    elseif b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)


-- Tag underline
tagline = wibox({border_width = 0, ontop = true, visible = true, type = "splash", x = 1723, y = 1078, width = 34, height = 2, screen = 1, bg = "#4082f7", fg = "#fefefe"})
tloldtag = 1
tlanim = false
tagline:connect_signal("button::press", function(mod,x,y,b)
    if b == 5 then awful.tag.viewidx(1)
    elseif b == 4 then awful.tag.viewidx(-1) end
end)

--[[
    Animate tagline back and forth between icons
    Should use cubic curve (ease in, ease out)
--]]

function animateTagline(newtagid,newtagpos)
    if newtagid == tloldtag then return end
    if tlanim then tagline:emit_signal("anim-interrupt") end
    local t = timer({timeout = 0.0035})
    callback = function()
        t:stop()
        --naughty.notify({text = "interrupt"})
        tagline:disconnect_signal("anim-interrupt", callback)
    end
    if newtagid-tloldtag > 0 then
        t:connect_signal("timeout", function()
            tagline.x = tagline.x + 2
            if tagline.x == newtagpos then
                t:stop()
                --naughty.notify({text = "normal stop"})
                tagline:disconnect_signal("anim-interrupt", callback)
                tlanim = false
                --tagline:emit_signal("anim-fin")
            elseif tagline.x > 1827 then
                t:stop()
                tagline.x = newtagpos
                tagline:disconnect_signal("anim-interrupt", callback)
                tlanim = false
            end
        end)
    else
        t:connect_signal("timeout", function()
            tagline.x = tagline.x - 2
            if tagline.x == newtagpos then
                t:stop()
                --naughty.notify({text = "normal stop"})
                tagline:disconnect_signal("anim-interrupt", callback)
                tlanim = false
                --tagline:emit_signal("anim-fin")
            elseif tagline.x < 1723 then
                t:stop()
                tagline.x = newtagpos
                tagline:disconnect_signal("anim-interrupt", callback)
                tlanim = false
            end
        end)
    end
    tagline:connect_signal("anim-interrupt", callback)
    tlanim = true
    t:start()
    --naughty.notify({text = "timer start"})
    tloldtag = newtagid
end

function animateTagline_dummy(newtagid,newtagpos)
    if tlanim then
        tagline:connect_signal("anim-fin", function()
            animateTagline(newtagid,newtagpos)
        end)
    end
end

-- X1: 1723, X2: 1757, X3: 1791, X4: 1827
awful.screen.focused():connect_signal("tag::history::update", function()
    --naughty.notify({text = "tag changed"})
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
        --naughty.notify({text = "CHROME"})
        if tagline.visible then -- if visible, commence animation
            animateTagline(1,1723)
        else tagline.x = 1723 end
    elseif awful.screen.focused().tags[2].selected then
        --naughty.notify({text = "PRODUCTIVITY"})
        if tagline.visible then
            animateTagline(2,1757)
        else tagline.x = 1757 end
    elseif awful.screen.focused().tags[3].selected then
        --naughty.notify({text = "SOCIAL"})
        if tagline.visible then
            animateTagline(3,1791)
        else tagline.x = 1791 end
    elseif awful.screen.focused().tags[4].selected then
        --naughty.notify({text = "GAMES"})
        if tagline.visible then
            animateTagline(4,1827)
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

--syswidget clickable cont
syscont = wibox.container.margin(mytextclock,10,10)
syscont:connect_signal("button::press",function(mod,x,y,b)
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

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
    --[[tags[s][1].icon = profileConfigPath.."headphones.png"
    tags[s][2].icon = profileConfigPath.."productivity.png"
    tags[s][3].icon = profileConfigPath.."headphones.png"
    tags[s][4].icon = profileConfigPath.."headphones.png"]]--

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    --[[s.mylayoutbox = awful.widget.layoutbox(s) -- 20x20 widget
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))]]--
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, custom_update)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 40 })

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
            --debugtxt,
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
    awful.key({modkey, "Shift"}, "o", function()
        syswidget.visible = not syswidget.visible
    end, {description = "opens syswidget", group = "awesome"}),
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
    awful.key({modkey}, "e", toggleLauncherImg, {description = "open search dialog", group = "awesome"}),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({modkey}, "t", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    --[[awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),]]--
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

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

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- App opening shortcuts
    awful.key({ modkey, "Shift" }, "m", function() awful.util.spawn("thunar") end, {description = "open file manager", group = "awesome"}),
    -- TAG-BASED KEYBINDINGS
    -- Open Chrome on CHROME tag
    awful.key({ modkey }, "n", function()
        local t = awful.screen.focused().selected_tag
        if t.index == 1 then awful.util.spawn("google-chrome")
        elseif t.index == 3 then awful.util.spawn("/usr/share/discord/Discord")
        elseif t.index == 4 then awful.util.spawn("/usr/bin/steam") end
    end, {description = "open Chrome", group = "tag"})
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
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    --[[awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),]]--
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
for i = 1, 9 do
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
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
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
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
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
    {rule = {class = "Google-chrome"}, properties = {screen = 1, tag = awful.screen.focused().tags[1]}},
    {rule = {class = "Firefox"}, properties = {screen = 1, tag = awful.screen.focused().tags[1]}},
    -- PRODUCTIVITY tag
    {rule = {class = "Atom"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Lmms"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Blender"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Dragonframe"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Ardour-5.8.0"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    {rule = {class = "Natron"}, properties = {screen = 1, tag = awful.screen.focused().tags[2]}},
    -- SOCIAL tag
    {rule = {class = "discord"}, properties = {screen = 1, tag = awful.screen.focused().tags[3]}},
    {rule = {instance = "crx_nckgahadagoaajjgafhacjanaoiihapd", class = "Google-chrome"}, properties = {screen = 1, tag = awful.screen.focused().tags[3]}},
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

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
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
    if awful.rules.match(c, {class = "Chrauncher"}) then
        c.x = 577
        c.y = 256
        c.border_width = 1
        c.border_color = "#8d8d8d"
    end
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
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        tagline.visible = false
    else
        tagline.visible = true
    end
end)

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

        --[[maximized:connect_signal("mouse::enter", function()
            beautiful.titlebar_maximized_button_focus_active = profileConfigPath.."themes/default/titlebar/maximized_focus_active2.png"
            beautiful.titlebar_maximized_button_focus_inactive = profileConfigPath.."themes/default/titlebar/maximized_focus_active2.png"
            maximized:emit_signal("widget::redraw_needed")
        end)]]--

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

-- Enable sloppy focus, so that focus follows mouse.
--[[client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)]]--

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
