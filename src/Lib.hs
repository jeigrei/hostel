module Lib where

import System.Directory
import Web.Scotty

configFile = do
  homedir <- getHomeDirectory
  let p = homedir ++ "/.hostel/config.yml"
  return p

 -- Errors
data HostelException = RequestedURIDoesNotExist
 | FileNotFoundOnDisk
 deriving (Eq, Show)
