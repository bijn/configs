# Notes

## bash-config.bash

Settings for temporary variables.

```bash
export SH_ROOT_DIR=$HOME/documents/configs
export SH_MISC_DIR=$SH_ROOT_DIR/misc
export SH_MODULE_DIR=$SH_ROOT_DIR/modules
export SH_SETTINGS_DIR=$SH_ROOT_DIR/shell
export SH_CONFIG_DIR=$SH_SETTINGS_DIR/config
export SH_TMP_DIR=$SH_CONFIG_DIR/tmp
```

## git-user.config

Temporary git settings (e.g. user name/email).

```
[user]
	name = <name>
	email = <email>
[github]
	user = <username>
[core]
	editor = emacs
```

## homebrew-vars.bash

Temporary homebrew settings and variables, like
`HOMEBREW_GITHUB_API_TOKEN`.

## xrandr.bash

Temporary xrandr settings.

```bash
xrandr --output HDMI-1 --left-of DP-1
xrandr --output DP-1 --preferred
```

Sourced in `xinitrc.bash`.
