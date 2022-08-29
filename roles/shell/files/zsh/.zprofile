# Desktop environment configured via ansible
export DESKTOP_ENVIRONMENT="xorg"

# Start ssh-agent if it is not running so we can use ssh-add
# Must be in the .profile instead of an .rc file, so that the
# agent can be used from all terminals.
if [[ "$(ps aux | grep ssh-agent | grep -v 'grep')" == "" ]]; then
  eval $(ssh-agent) > /dev/null
fi

# Start sway desktop if it is not already running on tty1
if [[ "$DESKTOP_ENVIRONMENT" == "wayland" ]]; then
  if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec sway
  fi
fi

# Automatically start xserver if it is not already running. This will make the desktop
# available to the user right after a successful login. The login itself is not styled.
if [[ "$DESKTOP_ENVIRONMENT" == "xorg" ]]; then
  if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec startx
  fi
fi
