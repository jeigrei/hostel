{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Files

import Data.Text.Internal.Lazy
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
      text "parseException"
      status internalServerError500
    Right h ->      
      case hostedFile of
        Left e -> do
          text "ffffuuu"
          status status404
        Right f -> do
          setHeader "Content-Type" "application/octet-stream"
          file $ path f
      where hostedFile = hostedFileFromURI uri h          

hello :: ActionM ()
hello = do
  html "<h1>Hello world!</h1>"

main = do
  putStrLn "Starting a server..."
  scotty 3000 $ hostel
