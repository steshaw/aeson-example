{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Lib (str)

import Control.Monad (mzero)
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as LBSC
import Data.Text

data Field = Field {
  wordcount :: Int
} deriving (Show)

instance FromJSON Field where
  parseJSON (Object o) = Field <$> o .: "wordcount"
  parseJSON _ = mzero

data Tag = Tag {
  id :: Text
} deriving (Show)

instance FromJSON Tag where
  parseJSON (Object o) = Tag <$> (o .: "id")
  parseJSON _ = mzero

data SearchResult = SearchResult {
  typ :: Text,
  fields :: Field,
  tags :: [Tag]
} deriving (Show)

instance FromJSON SearchResult where
  parseJSON (Object v) = SearchResult <$> v .: "type" <*> v .: "fields" <*> v .: "tags"
  parseJSON _ = mzero

data ContentrResult = ContentrResult {
  results :: [SearchResult],
  status :: Text
} deriving (Show)

instance FromJSON ContentrResult where
  parseJSON (Object v) = ContentrResult <$> v.: "results" <*> v .: "status"
  parseJSON _ = mzero

data Response = Response {
  response :: ContentrResult
} deriving (Show)

instance FromJSON Response where
  parseJSON (Object v) = Response <$> v .: "response"
  parseJSON _ = mzero

responseJson :: String
responseJson = [str|
  {
    "response": {
      "status": "ok",
      "results": [
        {
          "type": "article",
          "fields": {
            "wordcount": 497
          },
          "tags": [
            {
              "id": "profile/barryglendenning"
            }
          ]
        }
      ]
    }
  }
|]

main :: IO ()
main = do
  print r
  putStrLn ""
    where
      r :: Maybe Response
      r = decode (LBSC.pack responseJson)
