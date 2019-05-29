{-# LANGUAGE DeriveGeneric,OverloadedStrings #-}

module Files where

import Lib
import GHC.Generics
import Data.Yaml
import Web.Scotty
import Debug.Trace
import Data.Either
import Data.Bifunctor
import Control.Monad.IO.Class (liftIO)
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

hostedList :: IO (Either HostelException HostedFileList)
hostedList = do
  f <- configFile
  decoded <- decodeFileEither f
  return $ first asHostelError decoded

hostedFileFromURI :: DT.Text -> HostedFileList -> Either HostelException HostedFile
hostedFileFromURI targetURI hostedList =
  if length matchingFiles == 1 then Right(head matchingFiles) else Left(RequestedURIDoesNotExist)
  where matchingFiles = [f | f <- (hostedFiles hostedList), uri f == DT.unpack targetURI]
