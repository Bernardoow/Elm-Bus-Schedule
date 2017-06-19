module Data.Legend
    exposing
        ( Legend
        , legendDecoder
        , legendsDecoder
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)


type alias Legend =
    { name : String
    , abbr : String
    }


legendsDecoder : Decoder (List Legend)
legendsDecoder =
    Decode.list legendDecoder


legendDecoder : Decoder Legend
legendDecoder =
    decode Legend
        |> required "name" Decode.string
        |> required "abbr" Decode.string
