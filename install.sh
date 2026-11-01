#!/bin/bash
# Installs the p5notify and personaMusic plugins and the helper scripts.
# Backs up whatever it replaces. Use --mango to also copy the MangoWM config.
set -e

here="$(cd "$(dirname "$0")" && pwd)"
dms_dir="$HOME/.config/dms"
bak="$dms_dir/backup-$(date +%Y%m%d_%H%M%S)"

for cmd in dms wf-recorder playerctl notify-send; do
  command -v "$cmd" >/dev/null || echo "warning: '$cmd' not found (see README requirements)"
done

mkdir -p "$dms_dir/plugins" "$HOME/.local/bin" "$bak"

for p in p5notify personaMusic; do
  if [ -d "$dms_dir/plugins/$p" ]; then
    cp -r "$dms_dir/plugins/$p" "$bak/"
    echo "backed up existing $p to $bak"
  fi
  mkdir -p "$dms_dir/plugins/$p"
  # copy code only; keep any assets (images, fonts, sounds) you already added
  cp -r "$here/dms/plugins/$p/." "$dms_dir/plugins/$p/"
done

[ -f "$dms_dir/profile-switcher.sh" ] && cp "$dms_dir/profile-switcher.sh" "$bak/"
cp "$here/dms/profile-switcher.sh" "$dms_dir/profile-switcher.sh"
chmod +x "$dms_dir/profile-switcher.sh"

for f in "$here"/bin/*; do
  name="$(basename "$f")"
  [ -f "$HOME/.local/bin/$name" ] && cp "$HOME/.local/bin/$name" "$bak/"
  cp "$f" "$HOME/.local/bin/$name"
  chmod +x "$HOME/.local/bin/$name"
done

if [ "$1" = "--mango" ]; then
  if [ -d "$HOME/.config/mango" ]; then
    cp -r "$HOME/.config/mango" "$bak/mango"
    echo "backed up existing mango config to $bak/mango"
  fi
  mkdir -p "$HOME/.config/mango"
  cp -r "$here/mango/." "$HOME/.config/mango/"
fi

echo
echo "Done. Next steps:"
echo " 1. Add the artwork/fonts/sounds listed in the README."
echo " 2. In dmsProfiles settings, set the apply command to:"
echo "    \$HOME/.config/dms/profile-switcher.sh"
echo " 3. Run: dms restart"
