module Views.Page exposing (frame, ActivePage(..), bodyId)

{-| The frame around a typical page - that is, the header and footer.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)
import Html.Lazy exposing (lazy2)


--import Views.Spinner exposing (spinner)

import Util exposing ((=>))


{-| Determines which navbar link (if any) will be rendered as active.
Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.
-}
type ActivePage
    = Other
    | Home
    | Line


{-| Take a page's Html and frame it with a header and footer.
The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.
isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)
-}
frame : Bool -> ActivePage -> Html msg -> Html msg
frame isLoading page content =
    div [ class "page-frame" ]
        [ viewHeader page isLoading
        , viewSubHeader
        , content
        , viewFooter
        ]



--viewHeader : ActivePage -> Maybe User -> Bool -> Html msg


viewHeader : ActivePage -> Bool -> Html msg
viewHeader page isLoading =
    nav [ class "navbar navbar-light" ]
        [--div [ class "container" ]
         --    [ a [ class "navbar-brand", Route.href Route.Home ]
         --        [ text "conduit" ]
         --    , ul [ class "nav navbar-nav pull-xs-right" ] <|
         --        lazy2 Util.viewIf isLoading spinner
         --            :: (navbarLink (page == Home) Route.Home [ text "Home" ])
         --
         --    ]
        ]


viewSubHeader : Html msg
viewSubHeader =
    div [ class "center-block" ]
        [ h1 [ class "text-center" ] [ text "Horários de ônibus de João Monlevade !" ]
        , h2 [ class "text-center" ] [ text "Horários de ônibus rápidos e fáceis de visualizarem!" ]
        , hr [] []
        ]


viewFooter : Html msg
viewFooter =
    footer [ class "center-block" ]
        [ h4 [ class "text-center" ] [ text "Atualizado no dia 26/12/2014." ]
        , h5 [ class "text-center" ] [ text "Horarios são da linhas da Escon e foram encontrados em : http://www.enscon.com.br/horarios.html." ]
        , h6 [ class "text-center" ] [ text "Qualquer erro ou alteração enviar email para bgomesdeabreu@gmail.com." ]
        ]


navbarLink : Bool -> Route -> List (Html msg) -> Html msg
navbarLink isActive route linkContent =
    li [ classList [ ( "nav-item", True ), ( "active", isActive ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


{-| This id comes from index.html.
The Feed uses it to scroll to the top of the page (by ID) when switching pages
in the pagination sense.
-}
bodyId : String
bodyId =
    "page-body"
