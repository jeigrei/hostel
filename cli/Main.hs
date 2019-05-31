{-# LANGUAGE OverloadedStrings #-}

module Main where

import Options.Applicative
import qualified System.Directory as SD

import Lib
import Files
import CLI

addFile :: String -> IO ()
addFile name = return ()        -- TODO

addToConfig :: FilePath -> Config -> IO ()
addToConfig fpath hosted = return () -- TODO

removeFile :: String -> IO ()
removeFile name = putStrLn ("Removing the file: " ++ name)
  
main :: IO ()
main = do
  opts <- execParser optsParser
  case optCommand opts of
    Add name -> addFile name
    Remove name -> removeFile name 
