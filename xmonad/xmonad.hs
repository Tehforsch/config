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
import XMobarConfig
import Colors

import qualified XMonad.StackSet as W

import qualified Data.Map as M

myScriptFolder = "~/projects/config/scripts/"

myWorkspaces = ["a","s","d","f","g","y","x","c","m"]

myTabConfig = def { inactiveBorderColor = myInactiveBgColor
                  , activeTextColor = myActiveFontColor }

myLayout = avoidStruts $ toggleLayouts (tabbed shrinkText myTabConfig) $ smartBorders $ windowNavigation (tiled ||| tiled ||| Mirror tiled ||| Full)

tiled = (Tall 1 (3/100) (1/2))

myConfig = def 
    { terminal = "kitty"
    , modMask = mod4Mask
    , focusFollowsMouse = False
    , workspaces = myWorkspaces
    , layoutHook =  myLayout 
    , focusedBorderColor = myActiveBorderColor
    , normalBorderColor = myInactiveBorderColor
    , manageHook = composeOne [
        isFullscreen -?> doFullFloat
    ]
    , startupHook = runScript "startup.sh"
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

spawnAndExitMode s = spawn s *> exitModeAndClearLabel

runScript s = spawn ("bash " ++ myScriptFolder ++ s)

runScriptAndExitMode s = runScript s *> exitModeAndClearLabel

normalMode :: Mode
normalMode = makeMode exitMode "Normal"
  [
    ("^", toggleWS),
    ("0", sendMessage ToggleStruts),
    ("h", sendMessage $ Go L),
    ("j", sendMessage $ Go D),
    ("k", sendMessage $ Go U),
    ("l", sendMessage $ Go R),
    ("a", sendMessage $ Go L),
    ("d", sendMessage $ Go R),
    ("Shift+a", sendMessage $ Move L),
    ("Shift+d", sendMessage $ Move R),
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
      ("^", toggleWS),
      ("q", kill)
    ]
  )

layoutMode :: Mode
layoutMode = makeMode (setMode "Normal") "Layout"
  [
    ("j", sendMessage NextLayout),
    ("e", sendMessage ToggleLayout),
    ("e", sendMessage $ JumpToLayout "Tabbed Simplest"),
    ("v", sendMessage $ JumpToLayout "Tall"),
    ("h", sendMessage $ JumpToLayout "Mirror Tall"),
    ("f", sendMessage $ JumpToLayout "Full")
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
main = xmonad $ ewmhFullscreen . ewmh
  $ modal [normalMode, launchMode, workspaceMode, mediaMode, findMusicMode, layoutMode]
  $ withSB myBar
  $ docks
  $ myConfig

