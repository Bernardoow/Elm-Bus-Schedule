module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (for, class, href, id, placeholder, attribute, classList, type_, style)
import Html.Events exposing (onClick, onInput)
import Request.Line
import Views.Page as Page
import Data.Line as Line exposing (Line)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Route exposing (Route)
import Task exposing (Task)
import Http
import Regex


-- MODEL --


type alias Model =
    { searchLine : String
    , lines : List Line
    }


init : Task PageLoadError Model
init =
    let
        handleLoadError errr =
            let
                de =
                    Debug.log "err" errr
            in
                pageLoadError Page.Home "Homepage is currently unavailable."

        loadLines =
            Request.Line.lines
                |> Http.toTask
    in
        Task.map (Model "") loadLines
            |> Task.mapError handleLoadError



-- VIEW --


viewLine : Line -> Html Msg
viewLine line =
    div [ class "col-md-3 col-xs-6 col-sm-3 col-lg-3", style [ ( "padding", "10px" ) ] ]
        [ a [ Line.createSlug line.name |> Route.Line |> Route.href, class "btn btn-primary btn-block btn-lg" ] [ text line.name ]
        ]


viewLines : String -> List Line -> Html Msg
viewLines search lines =
    let
        regex_ =
            Regex.caseInsensitive (Regex.regex search) |> Regex.contains

        list =
            if String.length search > 0 then
                List.filter (\item -> regex_ item.name) lines
                    |> List.map (\line -> viewLine line)
            else
                List.map (\line -> viewLine line) lines
    in
        div [ class "col-xs-12 col-sm-8 col-md-8 col-lg-8 row" ] list


viewSidesAds : Html Msg
viewSidesAds =
    div [ class "col-xs-0 col-sm-2 col-md-2 col-lg-2 hidden-xs" ]
        [ div [ class "sidebar" ]
            []
        ]


viewSearchLines : Html Msg
viewSearchLines =
    div [ class "form-group", style [ ( "padding", "20px" ) ] ]
        [ label [ for "lineSearch" ] [ text "Busca de linhas" ]
        , input [ onInput SearchInput, class "form-control", id "lineSearch", placeholder "Digite a linha", type_ "email" ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ div [ class "container-fluid page" ]
            [ div [ class "row hidden-sm hidden-md hidden-lg" ]
                [ viewSearchLines ]
            , div
                [ class "row" ]
                [ viewSidesAds
                , viewLines model.searchLine model.lines
                , viewSidesAds
                ]
            ]
        ]



-- UPDATE --


type Msg
    = SearchInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput newSearch ->
            { model | searchLine = newSearch } ! []
