import Data.Char
import XMonad
import qualified XMonad.StackSet as W
import System.Exit
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.DwmStyle

myTerminal = "alacritty"
myMenu = "dmenu_run -fn 'Mononoki Nerd Font Mono-13' -p '>' -nb '#25111c' -sf '#8eb358' -sb '#25111c'"
myBrowser = "firefox"
myFileManager = "pcmanfm"

myFocusedBorderColor = "#8eb358"
myNormalBorderColor = "#2b2a33"
myBorderWidth = 1

myKeys = 
    [ ("M-i"          , spawn myBrowser )
    , ("M-<Return>"   , spawn myTerminal)
    , ("M-d"          , spawn myMenu)
    , ("M-g"          , spawn myFileManager)
    , ("M-e e"        , spawn "emacsclient -c")
    , ("M-f s"        , spawn "flatpak run com.spotify.Client")
    , ("M-S-q"        , kill)
    , ("M-S-<Return>" , windows W.swapMaster)
    , ("M-S-x"        , io $ exitWith ExitSuccess)
    , ("M-x"          , spawn recompile)
    ]
  where
    recompile = "xmonad --recompile; xmonad --restart"

myRmKeys =
    [ "M-p"
    , "M-q"
    ]
    
myLayout = avoidStruts 
    $ lessBorders Screen
    $ spacingRaw True (Border 8 8 8 8) True (Border 0 0 8 8) True
    (tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
    threeCol = ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1
    ratio    = 1/2
    delta    = 3/100

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent = xmobarBorder "Bottom" "#8eb358" 1
    , ppVisible = wrap "<" ">"
    , ppHidden  = white
    , ppSep     = magenta  " ][ "
    , ppTitle   = wrap "" (magenta " ]") . map toLower . shorten 100
    , ppLayout  = white . map toLower
    }
  where
    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#8be9fd" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
    green    = xmobarColor "#8eb358" ""
    black    = xmobarColor "#0d1117" ""

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp"         --> doFloat
    , isDialog                    --> doFloat
    , className =? "Lxappearance" --> doFloat
    , className =? "KeePassXC"    --> doFloat
    , className =? "qt5ct"        --> doFloat
    , appName   =? "Places"       --> doFloat
    , title     =? "Friends List" --> doFloat
    ]

myConfig = def
    { modMask            = mod4Mask
    , terminal           = myTerminal 
    , layoutHook         = myLayout
    , manageHook         = myManageHook
    , startupHook        = myStartupHook
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor  = myNormalBorderColor
    , borderWidth        = myBorderWidth
    --, workspaces         = ["▗", "▝", "▐", "▖", "▄", "▞", "▟", "▘", "▚"]
    }
    `additionalKeysP` myKeys
    `removeKeysP` myRmKeys

myStartupHook = do
    return ()
    checkKeymap myConfig myKeys

main :: IO()
main = xmonad 
    . ewmhFullscreen 
    . ewmh
    . withSB (statusBarProp "xmobar" (pure myXmobarPP)) 
    . docks
    $ myConfig

