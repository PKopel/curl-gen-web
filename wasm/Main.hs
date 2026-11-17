{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE JavaScriptFFI #-}

module Main where

import           GHC.Wasm.Prim                  ( JSString(..)
                                                , fromJSString
                                                , toJSString
                                                )
import           Data.Text                      ( Text
                                                , pack
                                                , unpack
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
main = pure ()

generateBash :: ScriptOptions -> Text -> Text
generateBash opts contents = case parseCurl contents of
    Left  s  -> pack s
    Right cu -> BashT.script opts $ map (BashF.writeFunction $ random opts) cu

generateBashJs :: Bool -> Bool -> JSString -> JSString
generateBashJs thrd rand = let opts = ScriptOptions thrd rand Bash
    in toJSString . unpack . generateBash opts . pack . fromJSString

generatePwsh :: ScriptOptions -> Text -> Text
generatePwsh opts contents = case parseCurl contents of
    Left  s  -> pack s
    Right cu -> PwshT.script opts $ map (PwshF.writeFunction opts) cu

generatePwshJs :: Bool -> Bool -> JSString -> JSString
generatePwshJs thrd rand = let opts = ScriptOptions thrd rand Powershell
    in toJSString . unpack . generatePwsh opts . pack . fromJSString



foreign export javascript "generateBash" generateBashJs :: Bool -> Bool -> JSString -> JSString
foreign export javascript "generatePwsh" generatePwshJs :: Bool -> Bool -> JSString -> JSString