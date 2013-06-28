module Main (main) where

import Rdioh
import Rdioh.Models

import Control.Monad.IO.Class (liftIO)
import Data.Maybe (listToMaybe)
import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)

rdioKey :: String
rdioKey = "bxtarzeaqz9ux6wxn2mktk42"

rdioSecret :: String
rdioSecret = "WhUSkf7rfK"

main :: IO ()
main = do
    args <- getArgs

    case args of
        (file:_) -> do
            entries <- fmap lines $ readFile file
            runRdioWithAuth rdioKey rdioSecret $ mapM_ addEntry entries

        _ -> return ()

addEntry :: String -> Rdio ()
addEntry entry = do
    mrdioAlbum <- findAlbum entry

    case mrdioAlbum of
        Just rdioAlbum -> do
            let foundEntry = albumArtist rdioAlbum ++ " " ++ albumName rdioAlbum

            if foundEntry == entry
                then rdioInfo $ "Exact match: " ++ foundEntry
                else rdioInfo $ "Loose match: " ++ entry ++ " -> " ++ foundEntry

            addAlbum rdioAlbum

        _ -> rdioError $ "No results: " ++ entry

findAlbum :: String -> Rdio (Maybe Album)
findAlbum entry = do
    ret <- search entry "Album" :: Rdio (Either String [Album])

    case ret of
        Right albums -> return $ listToMaybe albums
        Left msg     -> rdioError msg >> (return $ Nothing)

addAlbum :: Album -> Rdio ()
addAlbum rdioAlbum = do
    _ <- addToCollection (trackKeys rdioAlbum)

    -- Sigh. Seems to always return Left with an error parsing the JSON
    -- response from Rdio, when in fact the album was added.
    return ()

rdioInfo :: String -> Rdio ()
rdioInfo = liftIO . putStrLn

rdioError :: String -> Rdio ()
rdioError = liftIO . hPutStrLn stderr
