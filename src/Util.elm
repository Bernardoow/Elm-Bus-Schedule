module Util exposing ((=>))

import Json.Decode as Decode
import Html.Events exposing (onWithOptions, defaultOptions)
import Html exposing (Attribute, Html)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)
