# Installation and updating script for Hyprland on Void Linux
This is a small install script for Hyprland on Void Linux.

This script ensures the availability of the official [void packages](https://github.com/void-linux/void-packages) on the local system, as well as the [template](https://github.com/Makrennel/hyprland-void) for Hyprland. It will install Hyprland, XDG-Desktop-Portals-Hyprland and Hyprpaper.

In short: it will download, install and update automatically.

This script will download and check for xbps-source repo with hyprland template in home/user/void. Consider editing the paths in the script to personal preference.

# **Update**
- Added full system update on script start
- Added git clone -- depth 1 to reduce bandwith usage
- Also added automatic highest cpu count to script for faster compiling of packages.
