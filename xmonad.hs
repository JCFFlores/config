{-# OPTIONS -fno-warn-missing-signatures #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.EZConfig
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Layout.TwoPane
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.ManageHelpers

keyBindings = [ ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
              , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-mute @DEFAULT_SINK@ 0; pactl set-sink-volume @DEFAULT_SINK@ -5%")
              , ("<XF86AudioRaiseVolume>", spawn "raise_volume.sh")
              , ("<Print>", spawn "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
              , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
              , ("<XF86ScreenSaver>", spawn "light-locker-command -l" )
              , ("M-f", sendMessage $ Toggle FULL)]

myConfig = ewmh def
  {
    terminal = "urxvtopen -e fish"
    , modMask = mod4Mask
    , borderWidth = 3
    , layoutHook = myLayout
    , manageHook = myManageHook <+> manageHook def
    , handleEventHook = handleEventHook def <+> fullscreenEventHook
  } `additionalKeysP` keyBindings

toggleStatusBar :: XConfig l -> (KeyMask, KeySym)
toggleStatusBar XConfig {modMask = modMask} = (modMask, xK_b)

myLayout =
  smartBorders . mkToggle1 FULL $
  Tall 1 (3 / 100) (1 / 2) ||| Grid ||| TwoPane (3 / 100) (1 / 2)

myManageHook = isFullscreen --> doFullFloat

main = xmonad =<< statusBar "xmobar" xmobarPP toggleStatusBar myConfig
