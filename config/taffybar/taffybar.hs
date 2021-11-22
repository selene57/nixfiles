{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}
module Main where

import           Control.Exception.Base
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Class
import           Control.Monad.Trans.Reader
import qualified Data.ByteString.Char8 as BS
import           Data.List
import           Data.List.Split
import qualified Data.Map as M
import           Data.Maybe
import qualified Data.Text
import           Data.Time
import qualified GI.Gtk as Gtk
import qualified GI.Gtk.Objects.Overlay as Gtk
import           Network.HostName
import           Paths_selene_taffybar                          (getDataDir)
import           StatusNotifier.Tray
import           System.Directory
import           System.Environment
import           System.Environment.XDG.BaseDir
import           System.FilePath.Posix
import           System.IO
import           System.Log.Handler.Simple
import           System.Log.Logger
import           System.Process
import           System.Taffybar
import           System.Taffybar.Auth
import           System.Taffybar.Context (appendHook)
import           System.Taffybar.DBus
import           System.Taffybar.DBus.Toggle
import           System.Taffybar.Hooks
import           System.Taffybar.Information.CPU
import           System.Taffybar.Information.EWMHDesktopInfo
import           System.Taffybar.Information.Memory
import           System.Taffybar.Information.X11DesktopInfo
import           System.Taffybar.SimpleConfig
import           System.Taffybar.Util
import           System.Taffybar.Widget
import           System.Taffybar.Widget.Generic.Icon
import           System.Taffybar.Widget.Generic.PollingGraph
import           System.Taffybar.Widget.Generic.PollingLabel
import           System.Taffybar.Widget.Util
import           System.Taffybar.Widget.Workspaces
import           Text.Printf
import           Text.Read hiding (lift)

setClassAndBoundingBoxes :: MonadIO m => Data.Text.Text -> Gtk.Widget -> m Gtk.Widget
setClassAndBoundingBoxes klass = buildContentsBox >=> flip widgetSetClassGI klass

decorateWithSetClassAndBoxes :: MonadIO m => Data.Text.Text -> m Gtk.Widget -> m Gtk.Widget
decorateWithSetClassAndBoxes klass builder = builder >>= setClassAndBoundingBoxes klass

makeCombinedWidget constructors = do
  widgets <- sequence constructors
  hbox <- Gtk.boxNew Gtk.OrientationHorizontal 0
  mapM (Gtk.containerAdd hbox) widgets

  Gtk.toWidget hbox

cssFilesByHostname =
  [ ("nixos", ["taffybar.css"]) ]

main = do
  hostName <- getHostName
  homeDirectory <- getHomeDirectory
  dataDir <- getDataDir

  let myLayoutWidget = 
        decorateWithSetClassAndBoxes "layout" $
         layoutNew defaultLayoutConfig

      myWorkspacesWidget = 
        flip widgetSetClassGI "workspaces" =<<
        workspacesNew defaultWorkspacesConfig

      myWindowsWidget = decorateWithSetClassAndBoxes "windows" $ windowsNew defaultWindowsConfig

      myClockWidget = decorateWithSetClassAndBoxes "clock" $ textClockNewWith defaultClockConfig
                  { clockUpdateStrategy = RoundedTargetInterval 60 0.0
                  , clockFormatString = "%I:%M %p"
                  }
      myTrayWidget = decorateWithSetClassAndBoxes "tray" $ sniTrayNewFromParams defaultTrayParams
                      { trayRightClickAction = PopupMenu
                      , trayLeftClickAction = Activate
                      }
      
      myMonitorsAction = usePrimaryMonitor
      myBarHeight = ScreenRatio (1 / 40)
      myBarPadding = 0
      myBarPosition = Top
      myWidgetSpacing = 5
      myStartWidgets = [ myLayoutWidget, myWorkspacesWidget]
      myCenterWidgets = [ myWindowsWidget ]
      myEndWidgets = [ myClockWidget, myTrayWidget ]
      relativeFiles = fromMaybe ["taffybar.css"] $ lookup hostName cssFilesByHostname
      myCSSPaths = map (dataDir </>) relativeFiles
      --myCSSPath = Just "~/nixfiles/config/taffybar/taffybar.css"
      myStartupHook = return ()


      simpleConfig = defaultSimpleTaffyConfig
                       { monitorsAction = myMonitorsAction
                       , barHeight = myBarHeight
                       , barPadding = myBarPadding
                       , barPosition = myBarPosition
                       , widgetSpacing = myWidgetSpacing
                       , startWidgets = myStartWidgets
                       , centerWidgets = myCenterWidgets
                       , endWidgets = myEndWidgets
                       , cssPaths = myCSSPaths
                       , startupHook = myStartupHook
                       }
  simpleTaffybar simpleConfig