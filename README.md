# abiotic-no-intro-fix

Skips Abiotic Factor startup movies on Linux/Proton.

Patches `Game.ini` (`[/Script/MoviePlayer.MoviePlayerSettings]`) to set:

```
bWaitForMoviesToComplete=False
bMoviesAreSkippable=True
StartupMovies=
```

## Usage

```bash
chmod +x no-intro.sh
./no-intro.sh
```

## Uninstall

Revert read-only and remove:

```bash
chmod u+w ~/.local/share/Steam/steamapps/compatdata/427410/pfx/drive_c/users/steamuser/AppData/Local/AbioticFactor/Saved/Config/Windows/Game.ini
rm -f ~/.local/share/Steam/steamapps/compatdata/427410/pfx/drive_c/users/steamuser/AppData/Local/AbioticFactor/Saved/Config/Windows/Game.ini
```


## Credit

Based on [Gametism's](https://www.nexusmods.com/abioticfactor/mods/1) mod, rewritten for Linux.
