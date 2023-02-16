screenLayouts:
{ config, pkgs, ... }:

let
    mod = config.xsession.windowManager.i3.config.modifier;

    i3Config = {
        # mod key is windows key
        modifier = "Mod4";
        floating.modifier = "Mod4";

        # font for window titles + bar
        fonts = {
            names = [ "Pango" "monospace" ];
            style = "";
            size = 10.0;
        };

        # double-switch should cause back-and-forth
        workspaceAutoBackAndForth = true;

        keybindings = {
            # kill focused window
            "${mod}+q" = "kill";

            # start dmenu
            "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

            # change focus
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            # move focused window
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            # move workspace
            "${mod}+Ctrl+Shift+Left" = "move workspace to output left";
            "${mod}+Ctrl+Shift+Down" = "move workspace to output down";
            "${mod}+Ctrl+Shift+Up" = "move workspace to output up";
            "${mod}+Ctrl+Shift+Right" = "move workspace to output right";

            # change container layout (stacked, tabbed, toggle split)
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            # split container layout
            "${mod}+Shift+s" = "split toggle; layout stacking";
            "${mod}+Shift+w" = "split toggle; layout tabbed";
            "${mod}+Shift+e" = "split toggle";

            # TODO: The following 2 needed?
            # jump to urgent window
            # "${mod}+x [urgent=latest] focus

            # enter fullscreen mode for the focused container
            # "${mod}+F11 fullscreen toggle

            # toggle tiling / floating
            "${mod}+Shift+space" = "floating toggle";

            # change focus between tiling / floating windows
            "${mod}+space" = "focus mode_toggle";

            # focus the parent/child container
            "${mod}+Prior" = "focus parent";
            "${mod}+Next" = "focus child";

            # move the currently focused window to the scratchpad
            "${mod}+Shift+minus" = "move scratchpad";

            # Show the next scratchpad window or hide the focused scratchpad window.
            # If there are multiple scratchpad windows, this command cycles through them.
            "${mod}+minus" = "scratchpad show";

            # switch to workspace
            "${mod}+1" = "workspace \"10:1\"";
            "${mod}+2" = "workspace \"20:2\"";
            "${mod}+3" = "workspace \"30:3\"";
            "${mod}+4" = "workspace \"40:4\"";
            "${mod}+5" = "workspace \"50:5\"";
            "${mod}+6" = "workspace \"60:6\"";
            "${mod}+7" = "workspace \"70:7\"";
            "${mod}+8" = "workspace \"80:8\"";
            "${mod}+9" = "workspace \"90:9\"";
            "${mod}+0" = "workspace \"100:10\"";

            # move focused container to workspace
            "${mod}+Shift+1" = "move container to workspace \"10:1\"";
            "${mod}+Shift+2" = "move container to workspace \"20:2\"";
            "${mod}+Shift+3" = "move container to workspace \"30:3\"";
            "${mod}+Shift+4" = "move container to workspace \"40:4\"";
            "${mod}+Shift+5" = "move container to workspace \"50:5\"";
            "${mod}+Shift+6" = "move container to workspace \"60:6\"";
            "${mod}+Shift+7" = "move container to workspace \"70:7\"";
            "${mod}+Shift+8" = "move container to workspace \"80:8\"";
            "${mod}+Shift+9" = "move container to workspace \"90:9\"";
            "${mod}+Shift+0" = "move container to workspace \"100:10\"";

            # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
            "${mod}+Shift+r" = "restart";

            # enter "resize" mode
            "${mod}+r" = "mode \"resize\"";

            ##########################
            # Audio & Screen Control #
            ##########################

            # The following prints all Pulseaudio sinks line-wise:
            #   pactl list short sinks | awk '{print $1}'
            # The following is executed for each line of input pactl command
            #   xargs -I {} sh -c 'pactl set-sink-volume {} -5%'

            # mute sound
            "XF86AudioMute"         = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-mute {} toggle'";
            "${mod}+F1"             = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-mute {} toggle'";
            # decrease sound volume
            "XF86AudioLowerVolume"  = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} -5%'";
            "${mod}+F2"             = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} -5%'";
            # increase sound volume
            "XF86AudioRaiseVolume"  = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} +5%'";
            "${mod}+F3"             = "exec pactl list short sinks | awk '{print $1}' | xargs -I {} sh -c 'pactl set-sink-volume {} +5%'";

            # screen brightness control
            # Note: Make `brightnessctl` executable in /etc/sudoers without password 
            "XF86MonBrightnessDown" = "exec sudo brightnessctl s 20%-";   # decrease screen brightness
            "${mod}+F5"             = "exec sudo brightnessctl s 20%-";   # decrease screen brightness
            "XF86MonBrightnessUp"   = "exec sudo brightnessctl s +20%";   # increase screen brightness
            "${mod}+F6"             = "exec sudo brightnessctl s +20%";   # increase screen brightness
            "XF86Display"           = "exec ${pkgs.lukestools}/bin/backlight-toggle";   # toggle screen
            "${mod}+F7"             = "exec ${pkgs.lukestools}/bin/backlight-toggle";   # toggle screen

            # change screen layout
            "${mod}+F9"  = "exec ${screenLayouts.standalone}";
            "${mod}+F10" = "exec ${screenLayouts.homeSingle}";
            "${mod}+F11" = "exec ${screenLayouts.homeDouble}";
            "${mod}+F12" = "exec ${screenLayouts.school}";


            ########
            # Misc #
            ########

            # screen capture
            "${mod}+F8" = "exec ${pkgs.flameshot}/bin/flameshot gui";                # launch flameshot


            ##################################
            # Application-specific: Floating #
            ##################################

            # Open
            "${mod}+Return" = "exec ${pkgs.i3}/bin/i3-sensible-terminal";

            #bindsym $mod+Shift+Return exec floating-term-cmd open-dir
            #bindsym $mod+o exec floating-term-cmd open-file
            #for_window [class="floating-terminal-cmd"] floating enable

            # Thunar
            "${mod}+z" = "exec ${pkgs.lukestools}/bin/i3-thunar-toggle";

            # xfce4-appfinder
            #for_window [class="Xfce4-appfinder"] floating enable


            # Todos etc. ("Scratch")
            #set $scratch_title "scratch \(Workspace\) - Visual Studio Code"
            #bindsym $mod+t exec i3-exec-unique title $scratch_title scratch_init; [title=$scratch_title] scratchpad show
            #for_window [title=$scratch_title] floating enable, move scratchpad, scratchpad show

            ####################################
            # Application-specific: Workspaces #
            ####################################

            # Firefox
            "${mod}+f"       = ''workspace "103:f"'';
            "${mod}+Shift+f" = ''move container to workspace "103:f"'';
        };

        window = {
	      commands = [
	        {
                command = "floating enable, move scratchpad, scratchpad show";
                criteria = { class = "Galculator"; };
	        }
	        {
                command = "floating enable, move scratchpad, scratchpad show";
                criteria = { class = "Calendar"; };
	        }
	        {
                command = "floating enable, move scratchpad, scratchpad show";
                criteria = { class = "School-admin"; };
	        }
	        {
                command = "floating enable, move scratchpad, scratchpad show";
                criteria = { class = "KeePassXC"; };
	        }
            {
                command = "floating enable";
                criteria = { class = "zoom"; };
	        }
	      ];
	    };

        assigns = {
            "103:f" = [{ class = "firefox"; }];
            "105:m" = [{ class = "Mail"; }]; 
        };

        # resize window (you can also use the mouse for that)
        modes = {
            resize = {
                "h" = "resize shrink width 10 px or 10 ppt";
                "j" = "resize grow height 10 px or 10 ppt";
                "k" = "resize shrink height 10 px or 10 ppt";
                "l" = "resize grow width 10 px or 10 ppt";
                "Shift+h" = "resize shrink width 50 px or 50 ppt";
                "Shift+j" = "resize grow height 50 px or 50 ppt";
                "Shift+k" = "resize shrink height 50 px or 50 ppt";
                "Shift+l" = "resize grow width 50 px or 50 ppt";
        
                # same bindings, but for the arrow keys
                "Left" = "resize shrink width 10 px or 10 ppt";
                "Down" = "resize grow height 10 px or 10 ppt";
                "Up" = "resize shrink height 10 px or 10 ppt";
                "Right" = "resize grow width 10 px or 10 ppt";
        
                # back to normal: Enter or Escape
                "Return" = "mode default";
                "Escape" = "mode default";
            };
        };

        bars = [{
            position = "bottom";

            workspaceButtons = true;
            workspaceNumbers = false;

            fonts = {
                names = [ "Pango" "monospace" ];
                style = "";
                size = 10.0;
            };
            
            statusCommand = "${pkgs.i3status}/bin/i3status";
	    }];

        startup = 
        [
            {
                # screen layout
                command = "${screenLayouts.standalone}";
                notification = false;
            }
            {
                # battery-low warning
                command = "${pkgs.i3-battery-popup}/i3-battery-popup -n -s ${pkgs.i3-battery-popup}/i3-battery-popup.wav";
                notification = false;
            }
            {
                # autokey
                # TODO not yet tracked by nix, maybe later?
                command = "autokey";
                notification = false;
            }
        ];
    };

    i3StatusConfig = {
        enable = true;
        enableDefault = false;
        general = {
            colors  = true;
            color_good = "#81a380";
            color_degraded = "#000000";
            color_bad = "#e25f6c";
            interval = 5;
        };
        modules = {
            "ipv6" = {
                position = 1;
            };
            "disk /" = {
                position = 2;
                settings = {
                    format = "%avail";
                };
            };
            "wireless _first_" = {
                position = 3;
                settings = {
                    format_up = "W: (%quality at %essid) %ip";
                    format_down = "W: down";
                };
            };
            "ethernet _first_" = {
                position = 4;
                settings = {
                    # if you use %speed, i3status requires root privileges
                    format_up = "E: %ip (%speed)";
                    format_down = "E: down";
                };
            };
            "battery all" = {
                position = 5;
                settings = {
                    format = "  %status %percentage %remaining  ";
                    format_down = "No battery";
                    status_chr = "CHR";
                    status_bat = "BAT";
                    status_unk = "UNK";
                    status_full = "FULL";
                };
            };
            "tztime local" = {
                position = 6;
                settings = {
                    format = "  %d.%m.  %H:%M  ";
                };
            };
            "volume master" = {
                position = 7;
                settings = {
                    format = "  ♪ %volume";
                    format_muted = "  ♪ %volume";
                    device = "default";
                    mixer = "Master";
                    mixer_idx = 0;
                    color_degraded = "#FF0000";
                };
            };
        };
    };
in

{
    xsession = {
        enable = true;
        numlock.enable = false;
        windowManager.i3 = {
            enable = true;
            config = i3Config;
        };

        # 1. Load keyboard layout
        # 2. Start xcape to map `Caps_Lock` (renamed to `ISO_Level3_Shift`) to `Alt+Z` (renamed to `Super_R+Z`)
        # -- The order of 1. and 2. is important! --
        initExtra = ''
            ${pkgs.keyboard-us-luckey}/bin/keyboard-us-luckey-activate
            ${pkgs.xcape}/bin/xcape -e 'ISO_Level5_Shift=Super_R|Z'
        '';
    };
    programs.i3status = i3StatusConfig;
}