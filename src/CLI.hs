module CLI where

import Options.Applicative
import Data.Semigroup ((<>))

data CLIError = TargetDoesNotExist | FailedToStartServer deriving (Eq, Show)

data Opts = Opts
  {
    optCommand :: !Command
  }
  
data Command = Add String | Remove String

optsParser :: ParserInfo Opts
optsParser =
      info
        (helper <*> programOptions)
        (fullDesc <> progDesc "one-off static file hosting for HTTP" <>
         header
          "hostel - an easy way to share files over an HTTP server")
  where
    programOptions :: Parser Opts
    programOptions =
      Opts <$> 
      hsubparser (addCommand <> removeCommand)
    addCommand :: Mod CommandFields Command
    addCommand =
      command
        "add"
        (info addOptions (progDesc "Begin serving a new file with the hostel server"))
    addOptions :: Parser Command
    addOptions =
      Add <$>
      strArgument (metavar "FILE" <> help "Name of the file to host")
    removeCommand :: Mod CommandFields Command
    removeCommand =
      command
        "delete"
        (info removeOptions (progDesc "Stop serving a file with the hostel server"))
    removeOptions :: Parser Command
    removeOptions =
      Remove <$>
      strArgument (metavar "FILE" <> help "Name of the file to stop hosting")
