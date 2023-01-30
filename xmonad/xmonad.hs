import XMonad

import XMonad.Hooks.Modal

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Hooks.EwmhDesktops

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

import XMonad.Util.Loggers

import XMonad.Actions.Navigation2D

import XMonad.Util.Run
import XMonad.Actions.CycleWindows


import qualified XMonad.StackSet as W

import qualified Data.Map as M

myWorkspaces = ["a","s","d","f","g","y","x","c","m"]

myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logMode]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

myConfig = def 
    { terminal = "kitty"
    , modMask = mod4Mask
    , focusFollowsMouse = False
    , workspaces = myWorkspaces
    }
  `additionalKeysP`
    [
      ("<F9>"  , setMode "Normal"),
      ("M-S-k"  , spawn "rofi -show run")
    ]

makeMode label layout = modeWithExit "<XF86ModeLock>" label (mkKeysEz
                                    (layout ++
                                     [
                                      ("<Escape>", exitModeAndClearLabel),
                                      ("<Tab>" , exitModeAndClearLabel),
                                      ("<F9>" , setMode "Normal")
                                     ]
                                    ))

exitModeAndClearLabel = setMode "" *> exitMode

defaultMode :: Mode
defaultMode = makeMode "" []

normalMode :: Mode
normalMode = makeMode "Normal"
  [
    ("j", windows W.focusDown),
    ("k", windows W.focusUp),
    ("f", windows W.focusMaster),
    ("S-J", rotFocusedDown),
    ("S-K", rotFocusedUp),
    ("s", setMode "Launch"),
    ("w", setMode "Workspace"),
    ("q", kill)
  ]

spawnAndExitLaunchMode s = spawn s *> exitModeAndClearLabel

launchMode :: Mode
launchMode = makeMode "Launch"
  [ 
    ("a", spawnAndExitLaunchMode "kitty --detach --hold taskwarrior-tui"),
    ("b", spawnAndExitLaunchMode "exec $scripts/bwfor.sh"),
    ("c", spawnAndExitLaunchMode "firefox"),
    ("e", spawnAndExitLaunchMode "emacsclient -c -n"),
    ("p", spawnAndExitLaunchMode "emacsclient -c -n -e '(open-project-alongside-terminal)'"),
    ("l", spawnAndExitLaunchMode "i3lock -c 000000"),
    ("m", spawnAndExitLaunchMode "thunderbird"),
    ("n", spawnAndExitLaunchMode "pcmanfm --no-desktop"),
    ("s", spawnAndExitLaunchMode "rofi -show run"),
    ("t", spawnAndExitLaunchMode "telegram-desktop"),
    ("k", spawnAndExitLaunchMode "kitty"),
    ("v", spawnAndExitLaunchMode "/opt/cisco/anyconnect/bin/vpnui"),
    ("z", spawnAndExitLaunchMode "zotero"),
    ("S+N", spawnAndExitLaunchMode "kitty -o font_size=20 newsboat -u $config/newsboat/urls -C $config/newsboat/config"),
    ("S+P", spawnAndExitLaunchMode "gpaste-client ui"),
    ("S+S", spawnAndExitLaunchMode "flameshot gui"),
    ("<F11>", spawnAndExitLaunchMode "bash /home/toni/projects/config/scripts/screenCapture.sh")
  ]

workspaceMode :: Mode
workspaceMode = makeMode "Workspace"
  [(workspace, windows $ W.greedyView workspace) | workspace <- myWorkspaces]

main :: IO ()
main = xmonad $ ewmhFullscreen $ ewmh
  $ modal [normalMode, launchMode, defaultMode, workspaceMode]
  $ withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig

