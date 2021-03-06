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

fileBrowser = "ranger"

activityMonitor = "gotop"

shell = "fish"

myModMask = mod4Mask

executeOnTerminal command = "urxvtopen -e " ++ command

keyBindings = [ ("<XF86AudioMute>", spawn "amixer set Master toggle")
              , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%-")
              , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
              , ("<Print>", spawn "scrot -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("S-<Print>", spawn "sleep 0.2; scrot -f -s -e 'mv $f ~/Pictures/ 2>/dev/null'")
              , ("C-<Print>", spawn "scrot -e 'xclip -selection c -t `file -b --mime-type $f` $f; rm $f'")
              , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
              , ("C-S-<Print>", spawn "sleep 0.2; scrot -f -s -e 'xclip -selection c -t `file -b --mime-type $f` $f'; rm $f")
              , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
              , ("M-f", sendMessage $ Toggle FULL)
              , ("M-i", sendMessage $ Toggle TWOPANE)
              , ("M-n", sendMessage NextLayout)
              , ("M-<Space>", spawn myTerminal)
              , ("M-r", spawn $ executeOnTerminal fileBrowser)
              , ("M-g", spawn $ executeOnTerminal activityMonitor)
              , ("M-w", kill)]

removedKeyBindings = ["M-S-<Return>"
                     , "M-S-c"]

removedMouseBindings = [ (myModMask, button1) ]

myTerminal = executeOnTerminal shell

myConfig = ewmh def
  {
    terminal = myTerminal
    , modMask = myModMask
    , borderWidth = 3
    , layoutHook = myLayout
    , manageHook = myManageHook <+> manageHook def
    , handleEventHook = fullscreenEventHook <+> handleEventHook def
  } `additionalKeysP` keyBindings `removeKeysP` removedKeyBindings `removeMouseBindings` removedMouseBindings

toggleStatusBar :: XConfig l -> (KeyMask, KeySym)
toggleStatusBar XConfig {modMask = mask} = (mask, xK_b)

myLayout =
  smartBorders . mkToggle (FULL ?? TWOPANE ?? EOT) $
  Tall 1 (3 / 100) (1 / 2) ||| Grid

myManageHook = isFullscreen --> doFullFloat

main = xmonad =<< statusBar "xmobar" xmobarPP toggleStatusBar myConfig
