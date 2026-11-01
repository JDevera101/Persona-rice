#!/bin/bash
# Installs the p5notify and personaMusic plugins and the helper scripts.
# Backs up whatever it replaces. Use --mango to also copy the MangoWM config.
set -e

here="$(cd "$(dirname "$0")" && pwd)"
dms_dir="$HOME/.config/dms"
bak="$dms_dir/backup-$(date +%Y%m%d_%H%M%S)"

missing_cmds=""
for cmd in dms wf-recorder playerctl notify-send pw-play; do
  command -v "$cmd" >/dev/null || missing_cmds="$missing_cmds $cmd"
done
if [ -n "$missing_cmds" ]; then
  echo "warning: missing commands:$missing_cmds"
  echo "  on Arch try: sudo pacman -S wf-recorder playerctl libnotify pipewire"
  echo "  (dms comes from DankMaterialShell, see the README)"
fi

mkdir -p "$dms_dir/plugins" "$HOME/.local/bin" "$bak"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "warning: ~/.local/bin is not in your PATH" ;; esac

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
  (cd "$here/mango" && find . -type f) | while read -r f; do
    dest="$HOME/.config/mango/$f"
    mkdir -p "$(dirname "$dest")"
    case "$f" in
      ./monitors.conf|./outputs.conf|./dms/outputs.conf)
        if [ -e "$dest" ]; then
          cp "$here/mango/$f" "$dest.example"
          echo "kept your $f (mine saved as $f.example)"
          continue
        fi
        echo "NOTE: $f is set for my monitors, edit it for yours"
        ;;
    esac
    cp "$here/mango/$f" "$dest"
  done
fi

echo
missing=0
for a in \
  p5notify/banner.png p5notify/fonts/Persona5main.ttf \
  p5notify/fonts/PersonifiedUXRegular.ttf p5notify/sounds/papersound.wav \
  personaMusic/assets/banner.png personaMusic/assets/futaba_frame.png \
  personaMusic/fonts/personafont.ttf personaMusic/fonts/PersonifiedUXRegular.ttf; do
  if [ ! -e "$dms_dir/plugins/$a" ]; then
    echo "missing asset: ~/.config/dms/plugins/$a"
    missing=1
  fi
done
[ "$missing" = 1 ] && echo "(the widgets still load without these but look plain, see the README)"

echo
echo "Done. Next steps:"
echo " 1. Add any missing artwork/fonts/sounds listed above."
echo " 2. In dmsProfiles settings, set the apply command to:"
echo "    \$HOME/.config/dms/profile-switcher.sh"
echo " 3. Run: dms restart"
