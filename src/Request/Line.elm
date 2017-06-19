module Request.Line 
    exposing (
        lines
        ,line
        )
import Data.Line as Line exposing (Line)
import HttpBuilder
import Http

lines :  Http.Request (List Line)
lines = 
    HttpBuilder.get "Static/lines.json"
    |> HttpBuilder.withExpect (Http.expectJson Line.linesDecoder)
    |> HttpBuilder.toRequest

line : String -> Http.Request Line
line url = 
    HttpBuilder.get url
    |> HttpBuilder.withExpect (Http.expectJson Line.lineDecoder)
    |> HttpBuilder.toRequest