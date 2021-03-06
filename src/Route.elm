module Route exposing (Route(..), href, modifyUrl, fromLocation)

import UrlParser as Url exposing (parseHash, s, (</>), string, oneOf, Parser)
import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Attributes as Attr
import Data.Line as Line exposing (Line)


-- ROUTING --


type Route
    = Home
    | Line Line.Slug


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Line (s "line" </> Line.slugParser)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []

                Line slug ->
                    [ "line", Line.slugToString slug ]
    in
        "#/" ++ (String.join "/" pieces)



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    let
        _ =
            Debug.log "fromLocation" location
    in
        if String.isEmpty location.hash then
            Just Home
        else
            parseHash route location
