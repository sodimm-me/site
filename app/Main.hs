{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Spock
import Web.Spock.Config

import Control.Monad.Trans
import Data.Monoid
import Data.IORef
import qualified Data.Text as T

import Network.Wai.Middleware.Static

-- data MySession = EmptySession
-- data MyAppState = DummyAppState (IORef Int)

main :: IO ()
main = do 
    -- ref <- newIORef 0
    spockCfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 8080 (spock spockCfg app)

app :: SpockM () sess state ()
app = do
    cache <- liftIO $ initCaching PublicStaticCaching
    middleware (staticPolicy' cache (hasPrefix "static")) -- Only allows reading from /static

    get root $ file "text/html" "html/homepage.html"
    
    -- get ("hello" <//> var) $ \name -> do
    --     (DummyAppState ref) <- getState
    --     visitorNumber <- liftIO $ atomicModifyIORef' ref $ \i -> (i+1, i+1)
    --     text ("Hello " <> name <> ", you are visitor number " <> T.pack (show visitorNumber))
