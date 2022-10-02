{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Asterius.Types
import           Asterius.Text
import           Data.Text                      ( Text
                                                , pack
                                                )
import           Bash.Function                 as BashF
                                                ( writeFunction )
import           Bash.Template                 as BashT
                                                ( script )
import           Powershell.Function           as PwshF
                                                ( writeFunction )
import           Powershell.Template           as PwshT
                                                ( script )
import           Parser.Curl                    ( parseCurl )
import           Types.Script                   ( ScriptOptions(..)
                                                , ScriptLang(..)
                                                )

main :: IO ()
main = error "built with --no-main"

generateBash :: ScriptOptions -> Text -> Text
generateBash opts contents = case parseCurl contents of
    Left  s  -> pack s
    Right cu -> BashT.script opts $ map (BashF.writeFunction $ random opts) cu

generateBashJs :: Bool -> Bool -> JSString -> JSString
generateBashJs thrd rand = let opts = ScriptOptions thrd rand Bash
    in textToJSString . generateBash opts . textFromJSString

generatePwsh :: ScriptOptions -> Text -> Text
generatePwsh opts contents = case parseCurl contents of
    Left  s  -> pack s
    Right cu -> PwshT.script opts $ map (PwshF.writeFunction opts) cu

generatePwshJs :: Bool -> Bool -> JSString -> JSString
generatePwshJs thrd rand = let opts = ScriptOptions thrd rand Bash
    in textToJSString . generatePwsh opts . textFromJSString



foreign export javascript "generateBash" generateBashJs :: Bool -> Bool -> JSString -> JSString
foreign export javascript "generatePwsh" generatePwshJs :: Bool -> Bool -> JSString -> JSString