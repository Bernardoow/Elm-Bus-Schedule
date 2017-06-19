module Data.Period
    exposing
        ( Period
        , periodDecoder
        , periodsDecoder
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, optional, custom, hardcoded)


type alias Period =
    { id : Int
    , name : String
    }


periodsDecoder : Decoder (List Period)
periodsDecoder =
    Decode.list periodDecoder


periodDecoder : Decoder Period
periodDecoder =
    decode Period
        |> required "id" Decode.int
        |> required "name" Decode.string
