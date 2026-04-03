-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- Build the config object
local config = wezterm.config_builder()

-- ====================== APPEARANCE ======================
config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 13

config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0

config.max_fps = 144 -- 240 is overkill for most people
config.status_update_interval = 50
config.inactive_pane_hsb = {
	brightness = 1.0,
	saturation = 1.0,
}
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- ====================== TAB BAR STYLING ======================
config.tab_max_width = 24
config.colors = {
	tab_bar = {
		background = "#303446", -- Base (matches terminal background)
		active_tab = {
			bg_color = "#8caaee", -- Blue
			fg_color = "#303446", -- Base
		},
		inactive_tab = {
			bg_color = "#303446", -- Base
			fg_color = "#c6d0f5", -- Text
		},
		inactive_tab_hover = {
			bg_color = "#303446", -- Base
			fg_color = "#ffffff", -- Pure white for hover
		},
		new_tab = {
			bg_color = "#303446",
			fg_color = "#c6d0f5",
		},
		new_tab_hover = {
			bg_color = "#414559",
			fg_color = "#c6d0f5",
		},
	},
}

local function get_tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = "    " .. (tab.tab_index + 1) .. ": " .. get_tab_title(tab) .. "    "
	if tab.is_active then
		return {
			{ Background = { Color = "#8caaee" } },
			{ Foreground = { Color = "#303446" } },
			{ Text = title },
		}
	end
	return {
		{ Text = title },
	}
end)

-- ====================== LEADER & KEYBINDINGS ======================
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Splits (tmux style)
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Tabs
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },

	-- Pane navigation (hjkl)
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Pane resizing (arrow keys)
	{ key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },

	-- Tab rename
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new tab name:",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Leader + number to jump to tab (0-9)
for i = 0, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i),
	})
end

-- ====================== CUSTOM STATUS ======================
wezterm.on("update-status", function(window, _)
	local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)
	if window:leader_is_active() then
		window:set_left_status(wezterm.format({
			{ Background = { Color = "#8caaee" } },
			{ Foreground = { Color = "#303446" } },
			{ Text = "  " .. utf8.char(0x1f30a) .. "  " },
			{ Background = { Color = "#303446" } },
			{ Foreground = { Color = "#8caaee" } },
			{ Text = SOLID_RIGHT_ARROW },
		}))
	else
		window:set_left_status("")
	end
end)

-- Return the final config
return config
