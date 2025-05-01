module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import BackendTask exposing (BackendTask)
import Browser.Dom as Dom
import Browser.Events
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Layout
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Task exposing (Task)
import UrlPath exposing (UrlPath)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type Msg
    = MenuClicked
    | GotViewport Dom.Viewport
    | GotElement String (Result Dom.Error Dom.Element)
    | OnScroll


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMenu : Bool
    , viewport : Maybe Dom.Viewport
    , element : Maybe Dom.Element
    , isElementHouseVisible : Bool
    , isElementSchoolVisible : Bool
    }


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init _ _ =
    ( { showMenu = False
      , viewport = Nothing
      , element = Nothing
      , isElementHouseVisible = False
      , isElementSchoolVisible = False
      }
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        MenuClicked ->
            ( { model | showMenu = not model.showMenu }, Effect.none )

        GotViewport viewport ->
            let
                updatedModel =
                    { model | viewport = Just viewport }
            in
            ( updatedModel
            , Effect.batch
                [ Effect.fromCmd (Task.attempt (GotElement "project-card-house") (Dom.getElement "project-card-house"))
                , Effect.fromCmd (Task.attempt (GotElement "project-card-school") (Dom.getElement "project-card-school"))
                ]
            )

        GotElement id result ->
            case result of
                Ok element ->
                    let
                        isVisible =
                            isElementInViewport model.viewport (Just element)
                    in
                    case id of
                        "project-card-house" ->
                            ( { model | element = Just element, isElementHouseVisible = isVisible }, Effect.none )

                        "project-card-school" ->
                            ( { model | element = Just element, isElementSchoolVisible = isVisible }, Effect.none )

                        _ ->
                            ( model , Effect.none )

                Err _ ->
                    ( model, Effect.none )

        OnScroll ->
            ( model
            , Effect.fromCmd (Task.perform GotViewport Dom.getViewport)
            )


isElementInViewport : Maybe Dom.Viewport -> Maybe Dom.Element -> Bool
isElementInViewport maybeViewport maybeElement =
    case ( maybeViewport, maybeElement ) of
        ( Just viewport, Just element ) ->
            let
                isMobileOrTablet =
                    viewport.viewport.width <= 1280 -- Adjust this value based on your mobile/tablet breakpoint

                scrollY =
                    viewport.viewport.y

                viewportHeight =
                    viewport.viewport.height

                navbarHeight =
                    50 -- Adjust this value to match the height of your navbar

                elementTop =
                    element.element.y

                elementHeight =
                    element.element.height

                elementBottom =
                    elementTop + elementHeight

                visibleHeight =
                    max 0 (min (elementBottom - (scrollY + navbarHeight)) viewportHeight - max (elementTop - (scrollY + navbarHeight)) 0)
            in
            if not isMobileOrTablet then
                False
            else
                visibleHeight >= (0.5 * elementHeight)

        _ ->
            False


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ _ =
    Browser.Events.onAnimationFrameDelta
        (\_ ->
            Effect.none
        )
        |> Sub.map (\_ -> OnScroll)


data : BackendTask FatalError Data
data =
    BackendTask.succeed ()


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (Html msg), title : String }
view _ _ model toMsg pageView =
    { body = Layout.view model.showMenu (toMsg MenuClicked) pageView.body
    , title = pageView.title
    }
