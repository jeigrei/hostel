module Lib where

import System.Directory
import Web.Scotty
import Data.Yaml.Internal (ParseException)

configFile = do
  homedir <- getHomeDirectory
  let p = homedir ++ "/.hostel/config.yml"
  return p

 -- Errors
data HostelException = RequestedURIDoesNotExist
 | FileNotFoundOnDisk
 | BadConfig
 deriving (Eq, Show)

class AsHostelError a where
  asHostelError :: a -> HostelException

instance AsHostelError ParseException where
  asHostelError _ = BadConfig
