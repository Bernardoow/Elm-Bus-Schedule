module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList, type_, style)
import Html.Events exposing (onClick)
import Request.Line
import Views.Page as Page
import Data.Line as Line exposing (Line)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Route exposing (Route)
import Task exposing (Task)
import Http


-- MODEL --


type alias Model =
    { lines : List Line
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
        Task.map Model loadLines
            |> Task.mapError handleLoadError



-- VIEW --


viewLine : Line -> Html Msg
viewLine line =
    div [ class "col-md-3 col-xs-6 col-sm-3 col-lg-3", style [ ( "padding", "10px" ) ] ]
        [ a [ Line.createSlug line.name |> Route.Line |> Route.href, class "btn btn-primary btn-block btn-lg" ] [ text line.name ]
        ]


viewLines : List Line -> Html Msg
viewLines lines =
    List.map (\line -> viewLine line) lines
        |> div [ class "col-xs-12 col-sm-8 col-md-8 col-lg-8 row" ]


viewSidesAds : Html Msg
viewSidesAds =
    div [ class "col-xs-0 col-sm-2 col-md-2 col-lg-2 hidden-xs" ]
        [ div [ class "sidebar" ]
            []
        ]


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ div [ class "container-fluid page" ]
            [ div [ class "row" ]
                [ viewSidesAds
                , viewLines model.lines
                , viewSidesAds
                ]
            ]
        ]



-- UPDATE --


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []
