import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig

defaultTerminal :: String
defaultTerminal = "urxvtopen -e fish"

defaultModMask :: KeyMask
defaultModMask = mod4Mask

defaultBorderWidth :: Dimension
defaultBorderWidth = 3

keyBindings :: [(String, X ())]
keyBindings = [ ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
              , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ -5%")
              , ("<XF86AudioRaiseVolume>", spawn "raise_volume.sh")
              , ("<Print>", spawn "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
              , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
              , ("<XF86ScreenSaver>", spawn "light-locker-command -l" )]

main :: IO ()
main = xmonad =<< xmobar (desktopConfig
  {
    terminal = defaultTerminal
    , modMask = defaultModMask
    , borderWidth = defaultBorderWidth
    , handleEventHook = fullscreenEventHook
  } `additionalKeysP` keyBindings)