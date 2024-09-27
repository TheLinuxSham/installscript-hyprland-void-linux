#! /bin/bash

read -s -p "Enter your sudo password: " user_input

parent_dir=$HOME/void/
void_pkgs_dir=$HOME/void/void-packages/
hypr_dir=$HOME/void/hyprland-void/

pkg_list=("hyprland" "xdg-desktop-portal-hyprland" "hyprpaper")

clear
echo "$user_input" | sudo -S xbps-install -Suy
echo "$user_input" | sudo -S xbps-install -y git

# check for dir
if [ ! -d "$parent_dir" ]; then
  mkdir "$parent_dir"
fi

# check for void-packages and updates
if [ ! -d "$void_pkgs_dir" ]; then
  cd "$parent_dir"
  git clone --depth 1 https://github.com/void-linux/void-packages
  cd "$void_pkgs_dir"
  ./xbps-src binary-bootstrap
else
  cd "$void_pkgs_dir"
  git clean -fd
  git reset --hard
  git pull
  ./xbps-src update-sys
fi

# check for hyprland repo and updates
if [ ! -d "$hypr_dir" ]; then
  cd "$parent_dir"
  git clone https://github.com/Makrennel/hyprland-void.git
  cd "$hypr_dir"
  echo "Copying stuff..."
  cat common/shlibs >> ../void-packages/common/shlibs
  cp -r srcpkgs/* ../void-packages/srcpkgs
  echo "first"
else
  cd "$hypr_dir"
  git pull
  echo "Copying stuff..."
  cat common/shlibs >> ../void-packages/common/shlibs
  cp -r srcpkgs/* ../void-packages/srcpkgs
  cd "$void_pkgs_dir"
  ./xbps-src update-sys
fi

# check if packages are installed
for pkg in "${pkg_list[@]}"; do
  result=$(xbps-query -l | awk '{ print $2 }' | xargs -n1 xbps-uhelper getpkgname | grep -x "$pkg")
  echo "Check if installed: $pkg"
  if [ ! "$result" == "$pkg" ]; then
    echo "Installing now: $pkg"
    cd "$void_pkgs_dir"
    ./xbps-src -j8 pkg "$pkg"
    sudo -S xbps-install -y -R hostdir/binpkgs "$pkg"
  fi
done
