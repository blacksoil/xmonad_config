import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.DynamicLog
import System.IO
import XMonad.Util.EZConfig(additionalKeys)

main = do
    xmproc <- spawnPipe "/home/aharijanto/.cabal/bin/xmobar /home/aharijanto/.xmonad/xmobar_config"
    xmonad $ defaultConfig
        {
            borderWidth = 1 -- Change widnow's border width
            , focusedBorderColor = "#cd8b00" -- Change focused window border color
            , normalBorderColor = "#ccccc"
            , manageHook = manageDocks <+> manageHook defaultConfig
            , layoutHook = avoidStruts $ layoutHook defaultConfig
            , logHook = dynamicLogWithPP xmobarPP
                            { ppOutput = hPutStrLn xmproc
                            , ppTitle = xmobarColor "green" "" . shorten 50
                            }
            , modMask = mod4Mask -- Rebind Mod to Win key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock") -- Win + Shift + z -> lock screen
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s") -- ctrl + PrtScrn -> screenshot one window 
        , ((0, xK_Print), spawn "scrot") -- PrtScren -> screenshot all windows
        ]
