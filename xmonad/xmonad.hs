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
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Tabbed

import qualified XMonad.StackSet as W

import qualified Data.Map as M

myActiveBgColor = "#484848"
myActiveBorderColor = "#ebdbb2"
myActiveFontColor = "#ebdbb2"
myActiveWindowBorderColor = "#928374"
myBgColor = "#1d2021"
myInactiveBgColor = "#1d2021"
myInactiveBorderColor = "#1d2021"
myInactiveFontColor = "#928374"


myScriptFolder = "~/projects/config/scripts/"

myWorkspaces = ["a","s","d","f","g","y","x","c","m"]

myTabConfig = def { inactiveBorderColor = myInactiveBgColor
                  , activeTextColor = myActiveFontColor }

myLayout = windowNavigation (toggleLayouts (windowNavigation (tabbed shrinkText myTabConfig)) (tiled ||| tiled ||| Mirror tiled))

tiled = (Tall 1 (3/100) (1/2))

myHidePP :: String -> String
myHidePP s = ""

makeWorkspaceTitle color = color . (wrap "[        "  "        ]")

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

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    active, inactive:: String -> String
    active  = xmobarColor myActiveFontColor ""
    inactive = xmobarColor myInactiveFontColor ""

myConfig = def 
    { terminal = "kitty"
    , modMask = mod4Mask
    , focusFollowsMouse = False
    , workspaces = myWorkspaces
    , layoutHook = myLayout 
    , focusedBorderColor = myActiveBorderColor
    , normalBorderColor = myInactiveBorderColor
    }
  `additionalKeysP`
    [
      ("<F9>"  , setMode "Normal")
    ]

makeMode parent label layout = modeWithExit "<XF86ModeLock>" label (mkKeysEz
                                    (layout ++
                                     [
                                      ("<Escape>", parent),
                                      ("<Tab>" , exitModeAndClearLabel),
                                      ("<F9>" , setMode "Normal")
                                     ]
                                    ))

exitModeAndClearLabel = setMode "" *> exitMode

defaultMode :: Mode
defaultMode = makeMode (setMode "") "" []

normalMode :: Mode
normalMode = makeMode (setMode "") "Normal"
  [
    ("h", sendMessage $ Go L),
    ("j", sendMessage $ Go D),
    ("k", sendMessage $ Go U),
    ("l", sendMessage $ Go R),
    ("Shift+h", sendMessage $ Move L),
    ("Shift+j", sendMessage $ Move D),
    ("Shift+k", sendMessage $ Move U),
    ("Shift+l", sendMessage $ Move R),
    ("f", windows W.swapMaster),
    ("m", windows W.focusMaster),
    ("S-j", windows W.swapDown),
    ("S-k", windows W.swapUp),
    ("s", setMode "Launch"),
    ("w", setMode "Workspace"),
    ("y", setMode "Media"),
    ("o", setMode "Layout"),
    ("e", sendMessage ToggleLayout),
    ("q", kill)
  ]

spawnAndExitMode s = spawn s *> exitModeAndClearLabel

runScript s = spawn ("bash " ++ myScriptFolder ++ s)

runScriptAndExitMode s = runScript s *> exitModeAndClearLabel

workspaceMode :: Mode
workspaceMode = makeMode (setMode "Normal") "Workspace"
  (
    [(workspace, windows $ W.greedyView workspace) | workspace <- myWorkspaces]
    ++ 
    [(("C-" ++ workspace), windows $ W.shift workspace) | workspace <- myWorkspaces]
    ++ 
    [(("S-" ++ workspace), (windows $ W.shift workspace) *> (windows $ W.greedyView workspace)) | workspace <- myWorkspaces]
    ++
    [
      ("q", kill)
    ]
  )

layoutMode :: Mode
layoutMode = makeMode (setMode "Normal") "Layout"
  [
    ("j", sendMessage NextLayout),
    ("e", sendMessage ToggleLayout),
    ("f", sendMessage $ JumpToLayout "Tabbed Simplest"),
    ("v", sendMessage $ JumpToLayout "Tall"),
    ("h", sendMessage $ JumpToLayout "Mirror Tall")
  ]

launchMode :: Mode
launchMode = makeMode (setMode "Normal") "Launch"
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
    ("S-r", spawnAndExitMode "xmonad --recompile && xmonad --restart"),
    ("<F11>", runScriptAndExitMode "screenCapture.sh")
  ]

mediaMode :: Mode
mediaMode = makeMode (setMode "Normal") "Media"
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
findMusicMode = makeMode (setMode "Media") "Find Music"
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
  $ modal [normalMode, launchMode, defaultMode, workspaceMode, mediaMode, findMusicMode, layoutMode]
  $ withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
  $ myConfig

