module Page.Line exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList, type_, style)
import Html.Events exposing (onClick)
import Request.Line
import Views.Page as Page
import Data.Line as Line exposing (Line)
import Data.Period as Period exposing (Period)
import Data.LineScheduleEntry as LineScheduleEntry exposing (LineScheduleEntry)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Route exposing (Route)
import Task exposing (Task)
import Http


-- MODEL --


type alias Model =
    { tab_period_selected : Int
    , period_id_selected : Maybe Int
    , line : Line
    }


init : String -> Task PageLoadError Model
init url =
    let
        handleLoadError errr =
            let
                de =
                    Debug.log "err" errr
            in
                pageLoadError Page.Home "Homepage is currently unavailable."

        loadLines =
            Request.Line.line
                ("Static/"
                    ++ url
                    ++ ".json"
                )
                |> Http.toTask
    in
        Task.map (Model 0 Nothing) loadLines
            |> Task.mapError handleLoadError



-- VIEW --


viewLineHeader : Line -> Html Msg
viewLineHeader line =
    let
        start =
            case line.start of
                Nothing ->
                    ""

                Just s ->
                    s

        end =
            case line.end of
                Nothing ->
                    ""

                Just e ->
                    e
    in
        div [ class "panel-heading" ]
            [ div [ class "page-header" ]
                [ h1 [] [ "Linha " ++ line.name |> text ]
                , div [ class "row" ]
                    [ div [ class "col-md-6" ] [ h2 [ class "pull-left" ] [ "Inicio: " ++ start |> text ] ]
                    , div [ class "col-md-6" ] [ h2 [ class "pull-right" ] [ "FIM: " ++ end |> text ] ]
                    ]
                ]
            ]


viewPeriodItem : Int -> String -> Bool -> Int -> Html Msg
viewPeriodItem id name selected index =
    let
        active =
            if selected then
                "active"
            else
                ""
    in
        li [ class active, ChangePeriod index id |> onClick ] [ a [] [ text name ] ]


viewPeriods : Model -> Html Msg
viewPeriods model =
    case model.line.periods of
        Nothing ->
            ul [ class "nav nav-tabs" ] []

        Just p ->
            List.indexedMap (,) p
                |> List.map (\( index, period ) -> viewPeriodItem period.id period.name (model.tab_period_selected == index) index)
                |> ul [ class "nav nav-tabs" ]


viewPeriodTable : Model -> Int -> Html Msg
viewPeriodTable model atBeginning =
    let
        entries =
            case model.line.entries of
                Nothing ->
                    Nothing

                Just entries ->
                    case model.period_id_selected of
                        Nothing ->
                            case model.line.periods of
                                Nothing ->
                                    Nothing

                                Just p ->
                                    if List.length p > 0 then
                                        (List.head p)
                                            |> Maybe.andThen (\item -> Just (List.filter (\entry -> entry.period == item.id && entry.atBeginning == atBeginning) entries))
                                    else
                                        Nothing

                        Just period ->
                            Just (List.filter (\entry -> entry.period == period && entry.atBeginning == atBeginning) entries)
    in
        case entries of
            Nothing ->
                table [ class "table table-striped table-bordered table-hover table-condensed" ]
                    [ tr []
                        [ th [] [ text "Horário" ]
                        , th [] [ text "Via" ]
                        ]
                    ]

            Just e ->
                let
                    create_tr_entry time info =
                        tr []
                            [ td [] [ text time ]
                            , td [] [ text info ]
                            ]

                    table_body =
                        (List.map (\entry -> create_tr_entry entry.time entry.info) e)

                    table_head =
                        thead []
                            [ tr []
                                [ th [] [ text "Horário" ]
                                , th [] [ text "Via" ]
                                ]
                            ]
                in
                    table [ class "table table-striped table-bordered table-hover table-condensed" ]
                        [ table_head
                        , tbody [] table_body
                        ]


viewPeriod model =
    div [ class "row" ]
        [ div [ class "col-md-6" ] [ viewPeriodTable model 1 ]
        , div [ class "col-md-6" ] [ viewPeriodTable model 0 ]
        ]


viewLineBody model =
    div [ class "panel-body" ]
        [ div [ class "row" ] [ viewPeriods model ]
        , div [ class "row" ] [ viewPeriod model ]
        ]


viewLineFooter : Line -> Html Msg
viewLineFooter line =
    let
        legend_text =
            case line.legends of
                Nothing ->
                    []

                Just l ->
                    List.map (\legend -> span [] [ strong [] [ text legend.name ], " : " ++ legend.abbr ++ " | " |> text ]) l
    in
        div [ class "panel-footer" ]
            [ legend_text |> p [] ]


viewLinePanel : Model -> Html Msg
viewLinePanel model =
    div [ class "panel panel-default" ]
        [ viewLineHeader model.line
        , viewLineBody model
        , viewLineFooter model.line
        ]


viewButton : Html Msg
viewButton =
    a [ class "btn btn-default btn-lg", href "#", attribute "role" "button", style [ ( "margin-bottom", "10px" ) ] ]
        [ span [ attribute "aria-hidden" "true", class "glyphicon glyphicon-arrow-left", style [ ( "margin-right", "10px" ) ] ] []
        , text "Voltar"
        ]


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ div [ class "container-fluid page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ p [] [ text "Popular Tags" ]
                        ]
                    ]
                , div [ class "col-md-6" ]
                    [ viewButton
                    , viewLinePanel model
                    ]
                ]
            ]
        ]



-- UPDATE --


type Msg
    = ChangePeriod Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangePeriod index id ->
            { model | tab_period_selected = index, period_id_selected = Just id } ! []
