{-# LANGUAGE OverloadedStrings #-}

module Main where

import Options.Applicative

import Lib
import Files
import CLI

main :: IO ()
main = do
  opts <- execParser optsParser
  case optCommand opts of
    Add name -> putStrLn("Adding the file: " ++ name)
    Remove name -> putStrLn ("Removing the file: " ++ name)
