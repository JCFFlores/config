{-# OPTIONS -fno-warn-missing-signatures #-}
{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances  #-}

import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.Grid
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders
import           XMonad.Layout.TwoPane
import           XMonad.Util.EZConfig

data TWOPANE = TWOPANE deriving (Read, Show, Eq, Typeable)

instance Transformer TWOPANE Window where
  transform _ x k = k (TwoPane (3 / 100) (1/2)) (const x)

fileBrowser = "hunter"

shell = "fish"

executeOnTerminal command = "urxvtopen -e " ++ command

keyBindings = [ ("<XF86AudioMute>", spawn "amixer set Master toggle")
              , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%-")
              , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
              , ("<Print>", spawn "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("S-<Print>", spawn "sleep 0.2; scrot -f -s -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
              , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
              , ("<XF86ScreenSaver>", spawn "light-locker-command -l" )
              , ("M-f", sendMessage $ Toggle FULL)
              , ("M-i", sendMessage $ Toggle TWOPANE)
              , ("M-n", sendMessage NextLayout)
              , ("M-<Space>", spawn myTerminal)
              , ("M-r", spawn $ executeOnTerminal fileBrowser)
              , ("M-w", kill)]

removedKeyBindings = ["M-S-<Return>"
                     , "M-S-c"]

myTerminal = executeOnTerminal shell

myConfig = ewmh def
  {
    terminal = myTerminal
    , modMask = mod4Mask
    , borderWidth = 3
    , layoutHook = myLayout
    , manageHook = myManageHook <+> manageHook def
    , handleEventHook = fullscreenEventHook <+> handleEventHook def
  } `additionalKeysP` keyBindings `removeKeysP` removedKeyBindings

toggleStatusBar :: XConfig l -> (KeyMask, KeySym)
toggleStatusBar XConfig {modMask = mask} = (mask, xK_b)

myLayout =
  smartBorders . mkToggle (FULL ?? TWOPANE ?? EOT) $
  Tall 1 (3 / 100) (1 / 2) ||| Grid

myManageHook = isFullscreen --> doFullFloat

main = xmonad =<< statusBar "xmobar" xmobarPP toggleStatusBar myConfig
