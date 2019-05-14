{-# LANGUAGE DeriveGeneric,OverloadedStrings #-}

module Files where

import Lib
import GHC.Generics
import Data.Yaml
import Web.Scotty
import Debug.Trace
import qualified Data.Text.Lazy as DT 

-- type URI = Text

data HostedFile = HostedFile { uri :: String,
                               path :: String
                             } deriving (Show, Generic)

data HostedFileList = HostedFileList { hostedFiles :: [HostedFile] } deriving (Show, Generic)

instance FromJSON HostedFileList
instance FromJSON HostedFile

localPath :: FilePath -> FilePath
localPath fp = reverse $ takeWhile (/= '/') $ reverse fp

hostedList :: IO (Either ParseException HostedFileList)
hostedList = do
  f <- configFile
  decodeFileEither f

hostedFileFromURI :: DT.Text -> HostedFileList -> Either HostelException HostedFile
hostedFileFromURI targetURI hostedList =
  if length matchingFiles == 1 then Right(head matchingFiles) else Left(RequestedURIDoesNotExist)
  where matchingFiles = [f | f <- (hostedFiles hostedList), uri f == DT.unpack targetURI]
