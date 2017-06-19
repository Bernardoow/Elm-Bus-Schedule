module Data.Line
    exposing
        ( Line
        , lineDecoder
        , linesDecoder
        , slugParser
        , Slug
        , slugToString
        , createSlug
        )

import Data.LineScheduleEntry exposing (LineScheduleEntry, lineScheduleEntriesDecoder)
import Data.Period exposing (Period, periodsDecoder)
import Data.Legend exposing (Legend, legendsDecoder)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)
import UrlParser
import Regex


type alias Line =
    { name : String
    , start : Maybe String
    , end : Maybe String
    , entries : Maybe (List LineScheduleEntry)
    , periods : Maybe (List Period)
    , legends : Maybe (List Legend)
    }


linesDecoder : Decoder (List Line)
linesDecoder =
    Decode.list lineDecoder


lineDecoder : Decoder Line
lineDecoder =
    decode Line
        |> required "name" Decode.string
        |> optional "start" (Decode.nullable Decode.string) Nothing
        |> optional "end" (Decode.nullable Decode.string) Nothing
        |> optional "entries" (Decode.nullable lineScheduleEntriesDecoder) Nothing
        |> optional "periods" (Decode.nullable periodsDecoder) Nothing
        |> optional "legends" (Decode.nullable legendsDecoder) Nothing



-- IDENTIFIERS --


type Slug
    = Slug String


slugParser : UrlParser.Parser (Slug -> a) a
slugParser =
    UrlParser.custom "SLUG" (Ok << Slug)


slugToString : Slug -> String
slugToString (Slug slug) =
    slug


createSlug : String -> Slug
createSlug word =
    Regex.replace Regex.All (Regex.regex " ") (\_ -> "-") word |> String.toLower |> Slug
