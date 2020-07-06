import System.IO
import System.Posix.Types
import System.Posix.Process

import XMonad

import XMonad.Actions.MouseResize
import XMonad.Actions.SpawnOn

import XMonad.Hooks.DynamicBars
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowArranger

import qualified XMonad.StackSet as W
import Data.Ratio
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)

import XMonad.Util.EZConfig
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run

import System.Taffybar.Support.PagerHints

---------------------------------------------------------------------------
-- Main
---------------------------------------------------------------------------

main = do

    xmonad

        $ ewmh
        $ addDescrKeys (myCheatsheetKey, showKeybindings) myKeys
        $ docks
        $ pagerHints
        $ myConfig

myConfig = def
    { borderWidth = myBorderWidth
    , clickJustFocuses = myClickJustFocuses
    , focusFollowsMouse = myFocusFollowsMouse
    --, normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , manageHook = myManageHook
    --, handleEventHook = myHandleEventHook
    , layoutHook = myLayoutHook
    --, logHook = myLogHook
    , modMask = myModMask
    --, mouseBindings = myMouseBindings
    , startupHook = myStartupHook
    , terminal = myTerminal
    , workspaces = myWorkspaces
    }

---------------------------------------------------------------------------
-- Applications
---------------------------------------------------------------------------

myTerminal = "alacritty"

---------------------------------------------------------------------------
-- HandleEventHook
---------------------------------------------------------------------------

myHandleEventHook = fullscreenEventHook <+> ewmhDesktopsEventHook

---------------------------------------------------------------------------
-- LogHook
---------------------------------------------------------------------------

myLogHook = ewmhDesktopsLogHook <+> do
    winset <- gets windowset
    let layoutString = description . W.layout . W.workspace . W.current $ winset
    io $ appendFile "/tmp/.xmonad-layout-log" (layoutString ++ "\n")

---------------------------------------------------------------------------
-- ManageHook
---------------------------------------------------------------------------

myManageHook :: ManageHook
myManageHook = 
        manageSpecific
    <+> manageDocks
    <+> myNamedScratchpadManageHook
    <+> manageSpawn
    where
        manageSpecific = composeOne
            [ resource =? "desktop_window" -?> doIgnore
            , resource =? "stalonetray" -?> doIgnore
            ]

--scratchpads
myScratchpads =
    [ NS "htop" htopCommand (title =? "htop") myCustomFloating
    , NS "notes" notesCommand (title =? "NVIM Notes") myCustomFloating
    ]

htopCommand = myTerminal ++ " --title 'htop' -e htop"
notesCommand = myTerminal ++ " --title 'NVIM Notes' -e nvim"

myCustomFloating = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)

myNamedScratchpadManageHook = namedScratchpadManageHook myScratchpads

---------------------------------------------------------------------------
-- Startup
---------------------------------------------------------------------------

myStartupHook = do
    spawn    "bash ~/.xmonad/startup.sh"
    spawn    "polybar xmonad"

---------------------------------------------------------------------------
-- Workspaces
---------------------------------------------------------------------------

workspaceHome = "1-Home"
workspaceWeb = "2-Web"
workspaceWork = "3-Work"

workspaceTerm = "4-Term"
workspaceCode = "5-Code"
workspaceDoc = "6-Doc"

workspaceWrite = "7-Write"
workspaceMusic = "8-Music"
workspaceMedia = "9-Media"

myWorkspaces = [workspaceHome, workspaceWeb, workspaceWork, workspaceTerm
                , workspaceCode, workspaceDoc, workspaceWrite
                , workspaceMusic, workspaceMedia]

---------------------------------------------------------------------------
-- Theme
---------------------------------------------------------------------------

-- color definitions
myFocusedBorderColor = "#BB00FF"

-- sizing
gap = 10
topBar = 10
myBorderWidth = 5
prompt = 20
status = 20

-- gaps
mySpacing = spacingRaw True (Border 0 10 10 10) True (Border 5 5 5 5) True

---------------------------------------------------------------------------
-- Layout Hook
---------------------------------------------------------------------------
myLayoutHook = myUniversalLayoutMod $ myLayouts

myUniversalLayoutMod = avoidStruts . mySpacing
myLayouts = myFull ||| myBSP ||| myTall

-- layouts
myFull = noBorders $ Full

myBSP = mouseResize $ windowArrange $ emptyBSP

myTall =
    Tall
    { tallNMaster = 1
    , tallRatioIncrement = 1/100
    , tallRatio = 1/2
    }

---------------------------------------------------------------------------
-- Key Bindings
---------------------------------------------------------------------------

-- mouse behavior
myFocusFollowsMouse = False
myClickJustFocuses = True

-- mod binding
myModMask = mod4Mask

myKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
myKeys conf = let

    subKeys name list = subtitle name : mkNamedKeymap conf list

    in

    subKeys "System"
    [ ("M-p", addName "Rofi drun" $ spawn "rofi -show drun")
    , ("M-S-l", addName "Lock Screen" $ spawn "slimlock")
    ] ^++^

    subKeys "Applications"
    [ ("M-w", addName "Firefox" $ spawn "firefox")
    ] ^++^

    subKeys "Scratchpads"
    [ ("M-S-t", addName "htop" $ namedScratchpadAction myScratchpads "htop")
    , ("M-S-n", addName "notes" $ namedScratchpadAction myScratchpads "notes")
    ]

-- Keybinding to display the keybinding cheatsheet (mod+?)
myCheatsheetKey :: (KeyMask, KeySym)
myCheatsheetKey = (myModMask .|. shiftMask, xK_slash)

-- How to display the cheatsheet (from Ethan Schoonover's config)
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings keyMap = addName "Show Keybindings" $ io $ do
    cheatsheet <- spawnPipe "zenity --text-info --font='ubuntumono 12'"
    hPutStr cheatsheet (unlines $ showKm keyMap)
    hClose cheatsheet
    return ()

-- Size and location of the popup
myCheatsheetSize = W.RationalRect (1%4) (1%4) (1%2) (1%2)

---------------------------------------------------------------------------
-- Utility / Misc.
---------------------------------------------------------------------------

--getVisibleWorkspaces = map W.tag $ map W.workspace $ W.screens