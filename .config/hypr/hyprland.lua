local RAW_SANDBOX = false

local WORKSPACE_AMOUNT = 10
local MAIN_MOD = "SUPER"
local CTRL = "CTRL"
local SHIFT = "SHIFT"
local RETURN = "RETURN"

local monitors = {
	{ output = "eDP-1", mode = "highres", position = "0x0", scale = 1.6 },
	{ output = "HDMI-A-1", mode = "1920x1080@120", position = "2560x0", scale = 1 },
}
local monitor_conf = {
	[1] = {
		mask = "", -- problem to fix later
	},
	[2] = {
		mask = CTRL,
	},
}

local autostart = {
	"pipewire",
	"pipewire-pulse",
	"wireplumber",
	"export $(dbus-launch)",
	"waybar",
	"hyprpaper",
	"dunst",
	"sunset",
	"wallpaper set -rp -c other",
	"swayidle -w timeout 300 'lock' timeout 360 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'lock'",
	"sway-audio-idle-inhibit",
}

local programs = {
	terminal = "foot",
	browser = "firefox",
	file_manager = "thunar",
	menu = "fuzzel",
}

if RAW_SANDBOX then
	print(_VERSION)

	local t
	t = setmetatable({}, {
		__call = function() return t end,
		__index = function() return t end,
	})

	hl = t
end

local format_keys = function(keys) return table.concat(keys, " + ") end
local hl_bind = function(keys, ...) return hl.bind(format_keys(keys), ...) end

hl.on("hyprland.start", function()
	for _, program in pairs(autostart) do
		hl.exec_cmd(program)
	end
end)

hl.env("GDK_SCALE", 2)
hl.env("XCURSOR_THEME", "BreezeX-Dark")
hl.env("XCURSOR_SIZE", 32)

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,

		border_size = 2,

		col = {

			--[[ active_border = "$color10 $color11 90deg #rgba(33ccffee) rgba(00ff99ee) 45deg",
			inactive_border = "$color6 #rgba(595959aa)", ]]
		},

		-- bezier = "linear, 0.0, 0.0, 1.0, 1.0",

		resize_on_border = false,

		allow_tearing = false,

		layout = "master",
	},

	decoration = {
		rounding = 8,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {

			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,

			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "default", style = "slidevert -100%" })

hl.config({
	dwindle = {
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})

hl.config({
	input = {
		kb_layout = "gb",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			-- disable_while_typing = false,
		},
	},
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

--
-- windowrule {
--     name = scratchpad
--     match:class = ^(scratchpad)$
--     workspace = special:scratchpad
--     float = on
-- }

for monitor_num = 1, #monitors do
	local monitor = monitors[monitor_num]
	local monitor_output = monitor.output
	local monitor_mask = monitor_conf[monitor_num].mask

	for workspace_num = 1, WORKSPACE_AMOUNT do
		local workspace = (monitor_num - 1) * WORKSPACE_AMOUNT + workspace_num
		local workspace_key = workspace % WORKSPACE_AMOUNT

		hl.workspace_rule({
			workspace = tostring(workspace),
			monitor = monitor_output,
		})

		hl_bind({ MAIN_MOD, monitor_mask, workspace_key }, hl.dsp.focus({ workspace = workspace }))
		hl_bind({ MAIN_MOD, monitor_mask, SHIFT, workspace_key }, hl.dsp.window.move({ workspace = workspace }))
	end
end

hl_bind({ MAIN_MOD, "H" }, hl.dsp.focus({ direction = "left" }))
hl_bind({ MAIN_MOD, "L" }, hl.dsp.focus({ direction = "right" }))
hl_bind({ MAIN_MOD, "K" }, hl.dsp.focus({ direction = "up" }))
hl_bind({ MAIN_MOD, "J" }, hl.dsp.focus({ direction = "down" }))

hl_bind({ MAIN_MOD, SHIFT, "H" }, hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl_bind({ MAIN_MOD, SHIFT, "L" }, hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl_bind({ MAIN_MOD, SHIFT, "K" }, hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl_bind({ MAIN_MOD, SHIFT, "J" }, hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

hl_bind({ MAIN_MOD, SHIFT, "F" }, hl.dsp.window.fullscreen({ action = "toggle" }))

hl_bind({ MAIN_MOD, "tab" }, hl.dsp.layout("swapnext"))
hl_bind({ MAIN_MOD, SHIFT, "tab" }, hl.dsp.layout("swapprev"))

hl_bind({ MAIN_MOD, RETURN }, hl.dsp.exec_cmd(programs.terminal))
hl_bind({ MAIN_MOD, SHIFT, "C" }, hl.dsp.window.close())
hl_bind({ MAIN_MOD, "S" }, hl.dsp.exec_cmd(programs.terminal))

hl_bind({ MAIN_MOD, "grave" }, hl.dsp.workspace.toggle_special("scratchpad"))

hl_bind({ MAIN_MOD, "ALT", "M" }, hl.dsp.exit())
hl_bind({ MAIN_MOD, "F" }, hl.dsp.exec_cmd(programs.browser))
hl_bind({ MAIN_MOD, "E" }, hl.dsp.exec_cmd(programs.file_manager))
hl_bind({ MAIN_MOD, "V" }, hl.dsp.window.float({ action = "toggle" }))
hl_bind({ MAIN_MOD, "P" }, hl.dsp.exec_cmd(programs.menu))
hl_bind({ MAIN_MOD, "A" }, hl.dsp.exec_cmd(programs.menu))

hl_bind({ MAIN_MOD, SHIFT, "P" }, hl.dsp.exec_cmd("")) --batch "dispatch togglefloating; dispatch pin"
hl_bind({ MAIN_MOD, "C" }, hl.dsp.exec_cmd("")) --bind = $mainMod, c, exec, hyprctl --batch "dispatch resizeactive exact 50% 50%; dispatch centerwindow"

hl_bind({ MAIN_MOD, "R" }, hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))

hl_bind({ "XF86AudioRaiseVolume" }, hl.dsp.exec_cmd("setvolume inc 5"))
hl_bind({ "XF86AudioLowerVolume" }, hl.dsp.exec_cmd("setvolume dec 5"))

hl_bind({ "XF86AudioMedia" }, hl.dsp.exec_cmd("playerctl play-pause"))
hl_bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("playerctl play-pause"))
hl_bind({ "XF86AudioStop" }, hl.dsp.exec_cmd("playerctl stop"))
hl_bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("playerctl previous"))
hl_bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("playerctl next"))

hl_bind({ "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("setbrightness inc 5"))
hl_bind({ "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("setbrightness dec 5"))
hl_bind({ MAIN_MOD, "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("setbrightness inc 1"))
hl_bind({ MAIN_MOD, "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("setbrightness dec 1"))

hl_bind({ MAIN_MOD, "ALT_R", "L" }, hl.dsp.exec_cmd("lock"))

hl_bind({ MAIN_MOD, "B" }, hl.dsp.exec_cmd("GRIMBLAST_EDITOR='satty --filename' grimblast -n -f edit area"))
hl_bind({ MAIN_MOD, "W" }, hl.dsp.exec_cmd("wallpaper set -rp -c other"))
hl_bind({ MAIN_MOD, SHIFT, "W" }, hl.dsp.exec_cmd("wallpaper set -rp -c anime"))
hl_bind({ MAIN_MOD, "K" }, hl.dsp.exec_cmd("keyboard_backlight toggle"))
hl_bind({ MAIN_MOD, SHIFT, "K" }, hl.dsp.exec_cmd("hyprctl kill"))
hl_bind({ MAIN_MOD, "D" }, hl.dsp.dpms())

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "foot --app-id scratchpad" })
hl.window_rule({
	name = "scratchpad",
	match = {
		class = "scratchpad",
	},
	float = true,
})
