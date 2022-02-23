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
import System.Taffybar.Support.PagerHints

import XMonad.Layout
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
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

---------------------------------------------------------------------------
-- Main
---------------------------------------------------------------------------

main = do

    xmonad

        $ addDescrKeys (myCheatsheetKey, showKeybindings) myKeys
        $ docks
        $ pagerHints
        $ myConfig

myConfig = def
    { borderWidth = myBorderWidth
    , clickJustFocuses = myClickJustFocuses
    , focusFollowsMouse = myFocusFollowsMouse
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , manageHook = myManageHook
    , handleEventHook = myHandleEventHook
    , layoutHook = myLayoutHook
    , logHook = myLogHook
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

myHandleEventHook = fullscreenEventHook <+> ewmhDesktopsEventHookCustom namedScratchpadFilterOutWorkspace

---------------------------------------------------------------------------
-- LogHook
---------------------------------------------------------------------------

myLogHook = ewmhDesktopsLogHookCustom namedScratchpadFilterOutWorkspace 

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
    , NS "music" musicCommand (title =? "Music Player") myCustomFloating
    ]

htopCommand = myTerminal ++ " --title 'htop' -e htop"
notesCommand = myTerminal ++ " --title 'NVIM Notes' -e nvim"
musicCommand = myTerminal ++ " --title 'Music Player' -e lollypop"

myCustomFloating = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)

myNamedScratchpadManageHook = namedScratchpadManageHook myScratchpads

---------------------------------------------------------------------------
-- Startup
---------------------------------------------------------------------------

myStartupHook = ewmhDesktopsStartup <+> do
    spawn    "bash ~/.xmonad/startup.sh"
    --spawn    "polybar xmonad"

---------------------------------------------------------------------------
-- Theme
---------------------------------------------------------------------------

-- color definitions
myFocusedBorderColor = "#C9CBFF"
--myFocusedBorderColor = "#CF8EF4" old color
myNormalBorderColor = "#575268"

-- sizing
gap = 10
topBar = 10
myBorderWidth = 5
prompt = 20
status = 20

-- gaps
mySpacing = spacingRaw True (Border 0 10 10 10) True (Border 5 5 5 5) True

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
workspaceGame = "8-Game"
workspaceMedia = "9-Media"

myWorkspaces = [workspaceHome, workspaceWeb, workspaceWork, workspaceTerm
                , workspaceCode, workspaceDoc, workspaceWrite
                , workspaceGame, workspaceMedia]

---------------------------------------------------------------------------
-- Layout Hook
---------------------------------------------------------------------------
myLayoutHook = myUniversalLayoutMod $ myLayouts

myUniversalLayoutMod = avoidStruts

myLayouts = fullFirstMod
            $ bspFirstMod
            $ tallFirstMod
            $ myDefaultLayoutOrder

myDefaultLayoutOrder = myFull ||| myBSP ||| myTall
fullFirstMod = onWorkspaces fullDefaultWorkspaces (myFull ||| myBSP ||| myTall)
bspFirstMod = onWorkspaces bspDefaultWorkspaces (myBSP ||| myTall ||| myFull)
tallFirstMod = onWorkspaces tallDefaultWorkspaces (myTall ||| myFull ||| myBSP)

fullDefaultWorkspaces = ["1-Home", "7-Write", "8-Game", "9-Media"]
bspDefaultWorkspaces = ["4-Term", "5-Code"]
tallDefaultWorkspaces = ["2-Web", "3-Work"]

-- layouts
myFull = renamed [Replace "Full"] $ mySpacing $ noBorders $ Full

myBSP = renamed [Replace "BSP"] $ mySpacing $ mouseResize $ windowArrange $ emptyBSP

myTall = renamed [Replace "Tall"] $ mySpacing $ Tall
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


rofi = spawn "rofi -no-lazy-grab -show drun -modi run,drun,window -theme ~/.config/rofi/launcher/style -drun-icon-theme \"candy-icons\" "

myKeys :: XConfig l -> [((KeyMask, KeySym), NamedAction)]
myKeys conf = let

    subKeys name list = subtitle name : mkNamedKeymap conf list

    in

    subKeys "System"
    [ ("M-p", addName "Rofi drun" $ rofi)
    , ("M-S-l", addName "Lock Screen" $ spawn "light-locker-command -l")
    ] ^++^

    subKeys "Applications"
    [ ("M-f", addName "Firefox" $ spawn "firefox")
    ] ^++^

    subKeys "Scratchpads"
    [ ("M-S-t", addName "htop" $ namedScratchpadAction myScratchpads "htop")
    , ("M-S-n", addName "notes" $ namedScratchpadAction myScratchpads "notes")
    , ("M-S-m", addName "music" $ namedScratchpadAction myScratchpads "music")
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
