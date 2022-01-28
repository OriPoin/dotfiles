-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
require("awful.autofocus")

-- {{{ Set colors
gears.wallpaper.set("#000000")
beautiful.bg_urgent = "0"
-- }}}

-- {{{ Noti Functions
-- Ugly replacement of Awesome native notifications
-- Use kde-frameworks/knotifications in Plasma
local noti = {}

noti.config = {presets = {critical = "critical"}}

function noti.notify(args)
    local urgency = noti.config.presets[args["preset"]]
    local summary = args["title"]
    local body = args["text"]
    awful.spawn(string.format('notify-send -u %s "%s" "%s"', urgency, summary, body))
end
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    noti.notify(
        {
            preset = noti.config.presets.critical,
            title = "Oops, there were errors during startup!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true
            noti.notify(
                {
                    preset = noti.config.presets.critical,
                    title = "Oops, an error happened!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end
-- }}}

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
terminal = "konsole"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Meta Key / Window Key
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
-- Layout : tile and floating
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Workspace
awful.screen.connect_for_each_screen(
    function(s)
        -- Each screen has its own tag table.
        awful.tag({"☳", "☴", "☵", "☲", "☶", "☱", "☰", "☷"}, s, awful.layout.layouts[1])
    end
)
-- }}}

-- {{{ Key bindings
globalkeys =
    gears.table.join(
    -- Standard program
    awful.key(
        {modkey},
        "Return",
        function()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key(
        {modkey, "Control"},
        "r",
        awesome.restart,
        {
            description = "reload awesome",
            group = "awesome"
        }
    ),
    awful.key(
        {modkey, "Shift"},
        "q",
        function()
            awful.spawn.with_shell("qdbus org.kde.ksmserver /KSMServer logout 0 3 3")
        end,
        {description = "quit awesome", group = "awesome"}
    ),
    -- Focus
    awful.key(
        {modkey},
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- Workspace manipulation
    awful.key({modkey}, "Tab", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey, "Shift"}, "Tab", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey, "Control"}, "Right", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({modkey, "Control"}, "Left", awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),
    -- Layout manipulation
    awful.key(
        {modkey, "Shift"},
        "j",
        function()
            awful.client.swap.byidx(1)
        end,
        {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "k",
        function()
            awful.client.swap.byidx(-1)
        end,
        {description = "swap with previous client by index", group = "client"}
    ),
    awful.key(
        {modkey, "Control"},
        "j",
        function()
            awful.screen.focus_relative(1)
        end,
        {description = "focus the next screen", group = "screen"}
    ),
    awful.key(
        {modkey, "Control"},
        "k",
        function()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}
    ),
    awful.key(
        {modkey},
        "l",
        function()
            awful.tag.incmwfact(0.05)
        end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {modkey},
        "h",
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "h",
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"},
        "l",
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Control", "Shift"},
        "Left",
        function()
            local tag = client.focus.screen.tags[(client.focus.first_tag.index - 2) % 8 + 1]
            awful.client.movetotag(tag)
            awful.tag.viewprev()
        end,
        {description = "move client to previous tag and switch to it", group = "layout"}
    ),
    awful.key(
        {modkey, "Control", "Shift"},
        "Right",
        function()
            local tag = client.focus.screen.tags[(client.focus.first_tag.index % 8) + 1]
            awful.client.movetotag(tag)
            awful.tag.viewnext()
        end,
        {description = "move client to next tag and switch to it", group = "layout"}
    )
)

clientkeys =
    gears.table.join(
    awful.key(
        {modkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"},
        "c",
        function(c)
            if (c.name ~= "Plasma" and c.name ~= "Desktop — Plasma") then
                c:kill()
            end
        end,
        {
            description = "close",
            group = "client"
        }
    ),
    awful.key(
        {modkey},
        "t",
        function()
            awful.layout.inc(1) -- Actually, toggle between floating and titling mode
        end,
        {description = "toggle floating", group = "client"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, here is 1 to 8
for i = 1, 8 do
    globalkeys =
        gears.table.join(
        globalkeys, -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Move client to tag.
        awful.key(
            {modkey, "Shift"},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        )
    )
end

clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = 0,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Force plasma shell backgrounds to sit at lowest Z
    {
        rule = {
            name = "Plasma"
        },
        properties = {
            floating = true,
            placement = awful.placement.no_offscreen
        }
    },
    -- Leave Desktop unreachable
    {
        rule = {
            name = "Desktop — Plasma"
        },
        properties = {
            below = true, -- Keep dsektop below all windows
            focusable = false, -- Dont send focus to desktop windows
            sticky = true, -- Visible on all tags
            floating = true, -- For tiling layouts, do not tile the desktop
            fullscreen = true
        }
    },
    -- Krunner
    {
        rule = {class = "krunner"},
        properties = {
            floating = true
        }
    },
    -- Weird windows
    {
        rule = {class = "systemsettings"},
        properties = {
            maximized = false
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {},
            class = {
                "Virt-manager",
                "steam_app_" .. "%d",
                "Steam",
                ".*.exe"
            },
            name = {},
            role = {
                "pop-up"
            }
        },
        properties = {
            floating = true
        }
    },
    {
        rule = {class = "plasmashell"},
        properties = {
            floating = true,
            sticky = true,
            size_hints_honor = true,
            placement = awful.placement.no_offscreen
        }
    }
}
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

-- Auto start
awful.spawn.with_shell("picom")
awful.spawn.with_shell("fcitx5")
