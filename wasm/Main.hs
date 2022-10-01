{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Asterius.Types
import           Asterius.Text
import           Bash.Function                 as BashF
                                                ( writeFunction )
import           Bash.Template                 as BashT
                                                ( script )
import           Powershell.Function           as PwshF
                                                ( writeFunction )
import           Powershell.Template           as PwshT
                                                ( script )
import           Parser.Curl                    ( parseCurl )

main :: IO ()
main = error "built with --no-main"

generateBash :: Text -> Text
generateBash contents = case parseCurl contents of
    Left  s  -> putStrLn s
    Right cu -> outFun . BashT.script $ map BashF.writeFunction cu

generateBashJs :: JSString -> JSString
generateBashJs = textToJSString . generateBash . textFromJSString

generatePowershell :: Text -> Text
generatePowershell = = case parseCurl contents of
    Left  s  -> putStrLn s
    Right cu -> outFun . PwshT.script $ map PwshF.writeFunction cu

generatePowershellJs :: JSString -> JSString
generatePowershellJs = textToJSString . generatePowershell . textFromJSString



foreign export javascript "generateBash"       generateBashJs       :: JSString -> JSString
foreign export javascript "generatePowershell" generatePowershellJs :: JSString -> JSString