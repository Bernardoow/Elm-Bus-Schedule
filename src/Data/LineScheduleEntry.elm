module Data.LineScheduleEntry 
    exposing (
        LineScheduleEntry
        ,lineScheduleEntryDecoder
        ,lineScheduleEntriesDecoder
        )
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, custom, hardcoded)

type alias LineScheduleEntry = {
    time: String
    ,info : String
    , period: Int
    , atBeginning: Int
}


lineScheduleEntryDecoder : Decoder LineScheduleEntry
lineScheduleEntryDecoder =
    decode LineScheduleEntry 
        |> required "time" Decode.string
        |> required "info" Decode.string
        |> required "period" Decode.int
        |> required "atBeginning" Decode.int

lineScheduleEntriesDecoder: Decoder (List LineScheduleEntry)
lineScheduleEntriesDecoder = 
    Decode.list lineScheduleEntryDecoder