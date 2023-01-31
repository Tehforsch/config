module XMobarConfig (myBar) where

import XMonad
  
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicIcons
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.Modal
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Util.ClickableWorkspaces
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run
import XMonad.Util.Ungrab
import XMonad.Config.Desktop
import Colors

import Colors

myXmobarPP = def
    {
      ppSep             = inactive "   •   "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = makeWorkspaceTitle active
    , ppHidden          = makeWorkspaceTitle inactive
    , ppVisible         = myHidePP
    , ppHiddenNoWindows = myHidePP
    , ppOrder           = \[ws, l, _, wins] -> [ws,  wins]
    , ppExtras          = [logMode]
    }
  where
    active, inactive:: String -> String
    active  = xmobarColor myActiveFontColor ""
    inactive = xmobarColor myInactiveFontColor ""

myHidePP :: String -> String
myHidePP s = ""

makeWorkspaceTitle color = color . (wrap "[  "  "  ]")

myAppIcon s = appIcon (" <fn=1>" ++ s ++ "</fn> ")

myIcons :: Query [String]
myIcons = composeAll
  [
    className =? "kitty" --> myAppIcon "\61728"
    , className =? "Emacs" --> myAppIcon "\61788"
    , className =? "TelegramDesktop" --> myAppIcon "\62150"
    , className =? "firefox" --> myAppIcon "\62057"
    , className =? "Thunderbird" --> myAppIcon "\61664"
    , className =? "thunderbird" --> myAppIcon "\61664"
    , className =? "Zathura" --> myAppIcon "\61889"
    , className =? "default_icon" --> myAppIcon "💀"
    , className =? "feh" --> myAppIcon "\61502"
    , className =? "Pavucontrol" --> myAppIcon "🎧"
    , className =? "Zotero" --> myAppIcon "Z"
    , className =? "pcmanfm" --> myAppIcon "🖿"
    , className =? "Pcmanfm" --> myAppIcon "🖿"
    , className =? "Spotify" --> myAppIcon "\61884"
    , className =? "spotify" --> myAppIcon "\61884"
  ]

myIconConfig = def{ iconConfigIcons = myIcons, iconConfigFmt = iconsFmtAppend concat }

myBar = statusBarProp "xmobar ~/projects/config/xmonad/xmobarrc" (clickablePP =<< dynamicIconsPP myIconConfig myXmobarPP)

