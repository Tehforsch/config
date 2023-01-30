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

import XMonad.Layout.WindowNavigation

import qualified XMonad.StackSet as W

import qualified Data.Map as M

myScriptFolder = "~/projects/config/scripts/"

myWorkspaces = ["a","s","d","f","g","y","x","c","m"]

myLayout = windowNavigation (Tall 1 (3/100) (1/2))

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
    , layoutHook = myLayout 
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
    ("h", sendMessage $ Go L),
    ("j", sendMessage $ Go D),
    ("k", sendMessage $ Go U),
    ("l", sendMessage $ Go R),
    ("f", windows W.swapMaster),
    ("m", windows W.focusMaster),
    ("S-j", windows W.swapDown),
    ("S-k", windows W.swapUp),
    ("s", setMode "Launch"),
    ("w", setMode "Workspace"),
    ("y", setMode "Media"),
    ("q", kill)
  ]

spawnAndExitMode s = spawn s *> exitModeAndClearLabel

runScript s = spawn ("bash " ++ myScriptFolder ++ s)

runScriptAndExitMode s = runScript s *> exitModeAndClearLabel

launchMode :: Mode
launchMode = makeMode "Launch"
  [ 
    ("a", spawnAndExitMode "kitty --detach --hold taskwarrior-tui"),
    ("b", runScriptAndExitMode "bwfor.sh"),
    ("c", spawnAndExitMode "firefox"),
    ("e", spawnAndExitMode "emacsclient -c -n"),
    ("p", spawnAndExitMode "emacsclient -c -n -e '(open-project-alongside-terminal)'"),
    ("l", spawnAndExitMode "i3lock -c 000000"),
    ("m", spawnAndExitMode "thunderbird"),
    ("n", spawnAndExitMode "pcmanfm --no-desktop"),
    ("s", spawnAndExitMode "rofi -show run"),
    ("t", spawnAndExitMode "telegram-desktop"),
    ("k", spawnAndExitMode "kitty"),
    ("v", spawnAndExitMode "/opt/cisco/anyconnect/bin/vpnui"),
    ("z", spawnAndExitMode "zotero"),
    ("S-n", spawnAndExitMode "kitty -o font_size=20 newsboat -u $config/newsboat/urls -C $config/newsboat/config"),
    ("S-p", spawnAndExitMode "gpaste-client ui"),
    ("S-s", spawnAndExitMode "flameshot gui"),
    ("<F11>", runScriptAndExitMode "screenCapture.sh")
  ]

workspaceMode :: Mode
workspaceMode = makeMode "Workspace"
  [(workspace, windows $ W.greedyView workspace) | workspace <- myWorkspaces]

mediaMode :: Mode
mediaMode = makeMode "Media"
  [
    ("a", spawn "mpc prev"),
    ("d", spawn "mpc next"),
    ("f", spawn "pactl set-sink-volume @DEFAULT_SINK@ -4%"),
    ("r", spawn "pactl set-sink-volume @DEFAULT_SINK@ +4%"),
    ("l", runScript "showLyrics.sh"),
    ("s", spawn "mpc toggle"),
    ("g", runScript "changeBrightness.sh -dec 300"),
    ("t", runScript "changeBrightness.sh -inc 300"),
    ("j", spawn "mpc seek +10"),
    ("k", spawn "mpc seek -10"),
    ("S-f", spawn "mpc volume -5"),
    ("S-r", spawn "mpc volume +5"),
    ("S-o", runScriptAndExitMode "screenConfiguration.sh"),
    ("S-d", spawnAndExitMode "redshift -O 3500 -b 0.4"),
    ("m", setMode "Find Music")
  ]

findMusicMode :: Mode
findMusicMode = makeMode "Find Music"
  [
    ("k", runScriptAndExitMode "musicSelection/artist.sh"),
    ("a", runScriptAndExitMode "musicSelection/album.sh"),
    ("s", runScriptAndExitMode "musicSelection/song.sh"),
    ("r", runScript "musicSelection/randomAlbum.sh"),
    ("t", runScriptAndExitMode "musicSelection/newSongThisAlbum.sh"),
    ("S-a", runScriptAndExitMode "musicSelection/quarantineAlbum.sh"),
    ("S-r", runScript "musicSelection/quarantineAlbum.sh --random")
  ]

main :: IO ()
main = xmonad $ ewmhFullscreen $ ewmh
  $ modal [normalMode, launchMode, defaultMode, workspaceMode, mediaMode, findMusicMode]
  $ withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig

