local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

batteryIcon = wibox.widget.imagebox()

watch(
    "acpi", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
        local batteryType
        local bar, status, charge, time = string.match(stdout, '(.+): (%a+), (%d+)%%')
        charge = tonumber(charge)
        if (charge >= 0 and charge < 20) then
            batteryType=20
            --show_battery_warning()
        elseif (charge >= 20 and charge < 40) then
            batteryType=40
        elseif (charge >= 40 and charge < 60) then
            batteryType=60
        elseif (charge >= 60 and charge < 80) then
            batteryType=80
        elseif (charge >= 80 and charge <= 100) then
            batteryType=100
        end

        batteryIcon:set_image(os.getenv("HOME") .. "/.config/awesome/battery-icons/" .. batteryType .. ".png")
    end
)

function show_battery_status()
    awful.spawn.easy_async([[bash -c 'acpi']],
        function(stdout, stderr, reason, exit_code)
            naughty.notify{
                text = stdout,
                title = "Battery status",
                timeout = 5, hover_timeout = 0.5,
                width = 400,
            }
        end
    )
end

function show_battery_warning()
    naughty.notify{
    text = "Huston, we have a problem",
    title = "Battery is dying",
    timeout = 5, hover_timeout = 0.5,
    position = "bottom_right",
    bg = "#F06060",
    fg = "#EEE9EF",
    width = 400,
}
end

-- popup with battery info
batteryIcon:connect_signal("mouse::enter", function() show_battery_status() end)
