# Persona 5 rice (MangoWM + DankMaterialShell, Arch Linux)

A Persona 5 themed desktop: P5 style notification banners, a Futaba music
player widget, and profile switching that turns the P5 parts on and off.

> Fan made, not affiliated with Atlus/SEGA. The Persona 5 artwork, fonts and
> sounds are NOT included here. See "Assets you need to add" below.

## What is in this repo

| Path | What it is |
|------|------------|
| `dms/plugins/p5notify/` | My DMS plugin: P5 notification banners (persona profile only) |
| `dms/plugins/personaMusic/` | My DMS widget: the Futaba music player |
| `dms/profile-switcher.sh` | Run on every profile switch. Turns the P5 parts on/off and sets do-not-disturb |
| `bin/dms-profile-notify` | Small helper called on profile switch |
| `bin/toggle-record.sh` | Screen recording toggle (`wf-recorder`, with desktop audio) |
| `mango/` | My MangoWM config (keybinds, rules, autostart) |

## Other DMS plugins I use (not included, install them from DMS)

Open DMS settings, go to Plugins, and install:

- `dmsProfiles` (profile switching, required)
- `persona5Calendar`
- `enderPulse`
- `depthscape` (used in the non-persona profiles)

## Requirements

- Arch Linux, [MangoWM](https://github.com/DreamMaoMao/mangowc), DankMaterialShell (DMS) with Quickshell
- `wf-recorder`, `playerctl`, `libnotify` (`notify-send`), PipeWire (`pw-play`)
- Optional: `matugen` for the generated colors

## Assets you need to add yourself

The plugins load these files. Add them in the plugin folders after installing.

**`~/.config/dms/plugins/p5notify/`**
- `banner.png` and/or `banner2.png` : the notification banner art (transparent PNG)
- `fonts/Persona5main.ttf` : title font
- `fonts/PersonifiedUXRegular.ttf` : body font
- `sounds/papersound.wav` : the pop-in sound (any short wav works)

**`~/.config/dms/plugins/personaMusic/`**
- `assets/banner.png` and `assets/futaba_frame.png`
- `fonts/personafont.ttf` and `fonts/PersonifiedUXRegular.ttf`

Without them the widgets still load but look plain. Check the license of every
font and image you download.

## Install

```
git clone https://github.com/JDevera101/Persona-rice.git
cd Persona-rice
./install.sh
```

The script backs up anything it replaces into `~/.config/dms/backup-<date>/`.
It does not touch your MangoWM config unless you run `./install.sh --mango`.

Then:

1. Install the plugins listed above from DMS.
2. In the `dmsProfiles` settings, set the **apply command** to
   `$HOME/.config/dms/profile-switcher.sh`.
3. Create profiles with the slugs the script expects: `persona`, `saber`,
   `elden-ring` (edit the `case` in `profile-switcher.sh` to use your own names).
4. If you use `mako`, `dunst` or `swaync`, stop it so DMS owns notifications
   (`systemctl --user mask mako.service`), then run `dms restart`.

## How the notification plugin works

- DMS owns the notification service. The plugin watches DMS's notification
  history and draws its own banner on top.
- `profile-switcher.sh` writes the active profile to
  `~/.config/dms/p5notify-profile`. The plugin only shows banners while that
  file says `persona`.
- In persona, do-not-disturb hides DMS's normal popups. Critical notifications
  bypass do-not-disturb, so the plugin also clears the stock popup for those.

## Credits

Built on DankMaterialShell and Quickshell. Persona 5 is owned by Atlus/SEGA.

## Troubleshooting

**The widgets load but look plain**
The Persona artwork, fonts and sounds are not in this repo. `install.sh` prints a `missing asset:` line for every file it can't find. Add them to the paths listed under "Assets you need to add yourself", then run `dms restart`.

**No P5 banners show up at all**
- Banners only appear while the active profile is `persona`. Check with `cat ~/.config/dms/p5notify-profile`.
- Make sure the `p5notify` plugin is enabled in DMS settings, under Plugins.
- If you run `mako`, `dunst` or `swaync`, stop it so DMS owns notifications (`systemctl --user mask mako.service`), then `dms restart`.
- Test with `notify-send "Test" "Hello"`.

**The plugin shows a red error in DMS settings**
Run `dms restart` and look at the terminal output of `dms run` for the exact file and line. Open an issue and paste that line.

**Profile switching does nothing**
In the `dmsProfiles` settings, the apply command must be `$HOME/.config/dms/profile-switcher.sh`. Your profile slugs must match the `case` in that script (`persona`, `saber`, `elden-ring`), or edit the script to use your own names.

**Wrong resolution, blank or misplaced monitor after `--mango`**
`monitors.conf` and `outputs.conf` are set for my screens. If you already had these files, the installer keeps yours and saves mine as `.example`. If you didn't, edit them for your own displays.

**`toggle-record.sh` or other helpers say "command not found"**
`~/.local/bin` is not in your PATH. Add it to your shell config, for example `export PATH="$HOME/.local/bin:$PATH"` in `~/.bashrc` or `~/.zshrc`, or `fish_add_path ~/.local/bin` in fish.

**Something else broke**
Open an issue and include what you ran, the full error text, and the output of `dms version` and `dms doctor`.
