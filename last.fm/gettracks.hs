module Main where

import System.Environment
import Text.XML.Light
import Network.URI
import Network.HTTP
import Data.Maybe

data Track = Track {
	artist :: String,
	name :: String,
	playcount :: Integer
}

getXML :: String -> IO Element
getXML url = do
	let Just uri = parseURI url
	Right rsp <- simpleHTTP $ Request uri GET [] ""
	return $ fromJust $ parseXMLDoc $ rspBody rsp

(%>) :: Element -> String -> Element
e %> s = fromJust $ findChild (q s) e
infixl 6 %>

q x = QName x Nothing Nothing

getPageNum :: String -> IO Integer
getPageNum account = do
	doc <- getXML $ "http://ws.audioscrobbler.com/2.0/?api_key=ae26d4892e373c6fc188acf7e3cb36c3&method=library.gettracks&page=0&user=" ++ account
	let Just tke = findElement (q "tracks") doc
	let Just tp = findAttr (q "totalPages") tke
	return $ read tp


getPage :: String -> Integer -> IO [Track]
getPage account page = do
	doc <- getXML $ "http://ws.audioscrobbler.com/2.0/?api_key=ae26d4892e373c6fc188acf7e3cb36c3&method=library.gettracks&page=" ++ show page ++ "&user=" ++ account
	let tracks = findElements (q "track") doc
	return $ map parseTrack tracks
	
parseTrack :: Element -> Track
parseTrack e = Track
	(strContent $ e %> "artist" %> "name")
	(strContent $ e %> "name")
	(read $ strContent $ e %> "playcount")

main = do
	(account:_) <- getArgs
	pagen <- getPageNum account
	pages <- mapM (getPage account) [1..pagen]
	putStr $ unlines $ map (\(Track a n p) -> a ++ " - " ++ n) $ filter (\x -> playcount x > 3) $ concat pages

