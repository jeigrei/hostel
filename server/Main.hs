{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Files

import Data.Text.Internal.Lazy
import qualified Data.Text.Lazy as DT
import Control.Monad.IO.Class (liftIO)
import Network.HTTP.Types.Status
import Web.Scotty

hostel :: ScottyM ()
hostel = do
  get "/h/:uri" serveURI

serveURI :: ActionM ()
serveURI = do
  uri <- param "uri"
  hosted <- liftIO hostedList
  case hosted of
    Left e -> do
      text $ DT.pack $ show e
      status internalServerError500
    Right h ->
      case hostedFile of
        Left e -> do
          text $ DT.pack $ show e
          status status404
        Right f -> do
          setHeader "Content-Type" "application/octet-stream"
          setHeader "Content-Disposition" "attachment"
          setHeader "filename" $ DT.pack $ localPath (path f)
          status status200
          file $ path f
      where hostedFile = hostedFileFromURI uri h

main = do
  scotty 3000 $ hostel

