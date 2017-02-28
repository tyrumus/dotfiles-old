local btcntdwn = 120
local bedtime = timer({timeout = 60})
local pofftime = timer({timeout = 1})
local wibox_bedtime = wibox({border_width = 0, ontop = true, visible = false, x = -300, y = 1, width = 300, height = 200})
local btcntdwntb = wibox.widget.textbox(tostring(btcntdwn))
wibox_bedtime.widget = btcntdwntb

pofftime:connect_signal("timeout", function()
	if btcntdwn <= 0 then
		awful.util.spawn("systemctl poweroff")
	else
		btcntdwn = btcntdwn-1
		btcntdwntb:emit_signal("widget::redraw_needed")
	end
end)

bedtime:connect_signal("timeout", function()
	local hr = tonumber(os.date("%H"))
	local min = tonumber(os.date("%M"))
	if hr >= 22 or hr <= 4 then
		if min > 15 and not pofftime.started then
			wibox_bedtime.visible = true
			wibox_bedtime.x = 1
			pofftime:start()
			bedtime:stop()
		end
	end
end)

bedtime:start()
