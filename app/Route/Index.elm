module Route.Index exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Blogpost exposing (Metadata)
import FatalError exposing (FatalError)
import Head
import Html
import Html.Attributes as Attrs
import Layout
import Layout.Blogpost
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { blogpostMetadata : List Metadata
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    Content.Blogpost.allBlogposts
        |> BackendTask.map (\allBlogposts -> List.map .metadata allBlogposts |> (\allMetadata -> { blogpostMetadata = allMetadata }))


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Layout.seoHeaders


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app model =
    { title = Settings.title
    , body =
        [ heroSection
        , projectsSection model.isElementHouseVisible model.isElementSchoolVisible
        , newsSection app.data.blogpostMetadata
        , contactSection
        ]
    }
        
heroSection =
        Html.node "section"
            [ Attrs.class "relative min-h-screen flex items-center justify-center hero-section"
            , Attrs.attribute "aria-labelledby" "hero-heading"
            ]
            [ Html.div [ Attrs.class "hero-bg" ] []
            , Html.div [ Attrs.class "absolute inset-0  bg-opacity-50 z-10" ] []
            , Html.div [ Attrs.class "relative z-20 text-center px-8" ]
                [ Html.h1 [ Attrs.id "hero-heading", Attrs.class "text-7xl font-extrabold tracking-tighter mb-8 animate-fade-in trqa-outline" ]
                    [ Html.text "TRQA." ]
                , Html.p [ Attrs.class "text-xl max-w-xl mx-auto mb-10 animate-fade-in animation-delay-200" ]
                    [ Html.text "opening gates to new fields" ]
                , Html.a [ Attrs.href "https://tranquera.co/#projects", Attrs.class "inline-block px-8 py-3 text-base uppercase tracking-widest transition animate-fade-in animation-delay-400" ]
                    [ Html.text "Explore" ]
                ]
            ]

projectsSection isElementHouseVisible isElementSchoolVisible =
        Html.node "section"
            [ Attrs.id "projects", Attrs.class "py-32 ", Attrs.attribute "aria-labelledby" "projects-heading" ]
            [ Html.div [ Attrs.class "container mx-auto px-8" ]
                [ Html.h2 [ Attrs.id "projects-heading", Attrs.class "text-6xl font-extrabold tracking-tighter text-center mb-32" ]
                    [ Html.text "Projects" ]
                , Html.div [ Attrs.class "flex flex-col gap-32" ]
                    [ projectCard isElementHouseVisible "Capybara House" "Connecting students with tailored accommodation solutions in Dublin." "https://capybara.house" "house"
                    , projectCard isElementSchoolVisible "Capybara School" "Offering English courses from leading Dublin-based institutions for global learners." "https://capybara.school" "school"
                    ]
                ]
            ]

newsSection blogpostMetadata =
        Html.node "section"
            [ Attrs.id "news", Attrs.class "py-32", Attrs.attribute "aria-labelledby" "news-heading" ]
            [ Html.div [ Attrs.class "container mx-auto px-8" ]
                [ Html.h2 [ Attrs.id "news-heading", Attrs.class "text-6xl font-extrabold tracking-tighter text-center mb-32" ]
                    [ Html.text "News" ]
                , Html.div [ Attrs.class "flex flex-col gap-32" ]
                    <| List.map Layout.Blogpost.viewListItem blogpostMetadata
                ]
            ]

contactSection =
        Html.node "section"
            [ Attrs.id "contact", Attrs.class "py-32  contact-section", Attrs.attribute "aria-labelledby" "contact-heading" ]
            [ Html.div [ Attrs.class "container mx-auto text-center" ]
                [ Html.h2 [ Attrs.id "contact-heading", Attrs.class "text-6xl font-extrabold tracking-tighter mb-10" ]
                    [ Html.text "Contact" ]
                , Html.p [ Attrs.class "text-xl tracking-wide max-w-xl mx-auto mb-10" ]
                    [ Html.text "Collaborate with us." ]
                , Html.a [ Attrs.href "mailto:info@tranquera.co", Attrs.class "inline-block  border border-white px-8 py-3 text-base uppercase tracking-widest hover:bg-black hover:text-white hover:dark:bg-white hover:dark:text-black focus:bg-white focus:text-black focus:outline-none focus:ring-2 focus:ring-white transition" ]
                    [ Html.text "Reach Out" ]
                ]
            ]
projectCard isElementVisible title description url type_ =
        let
            secondWordClass =
                if type_ == "house" then
                    if isElementVisible then
                        "second-word-house dark:text-black text-white"
                    else
                    "second-word-house dark:group-hover:text-black group-hover:text-white"
                else
                    if isElementVisible then
                        "second-word-school dark:text-black text-white"
                    else
                    "second-word-school dark:group-hover:text-black group-hover:text-white"

            cardContentClass =
                if type_ == "house" then
                    "card-content-house"
                else
                    "card-content-school"

            inView =
                if isElementVisible then
                    "in-view"
                else
                    ""

            descClass =
                if type_ == "house" then
                    if isElementVisible then
                        "description-house dark:text-black text-white transition"
                    else
                        "description-house dark:group-hover:text-black group-hover:text-white"
                    
                else
                    if isElementVisible then
                        "description-school dark:text-black text-white transition"
                    else
                        "description-school dark:group-hover:text-black group-hover:text-white"
        in
        Html.article [ Attrs.id ("project-card-" ++ type_), Attrs.class "project-card-container" ]
            [ Html.a [ Attrs.href url, Attrs.attribute "target" "_blank", Attrs.class ("project-card flex flex-col md:flex-row items-center md:items-start group " ++ inView), Attrs.attribute "aria-label" ("Visit " ++ title) ]
            [ Html.div [ Attrs.class (cardContentClass ++ " flex flex-col md:flex-row items-center md:items-start w-full") ]
                [ Html.h3 [ Attrs.class "text-5xl md:text-6xl lg:text-7xl font-extrabold tracking-tighter w-full md:w-1/2 m-5 md:m-10 lg:m-20 space-x-1 md:space-x-3 lg:space-x-5 text-center md:text-left" ]
                [ Html.span [ Attrs.class "title-capybara" ] [ Html.text "Capybara" ]
                , Html.span [ Attrs.class secondWordClass ] [ Html.text (if type_ == "house" then "House" else "School") ]
                ]
                , Html.p [ Attrs.class (descClass ++ " text-base md:text-lg lg:text-xl tracking-wide w-full md:w-1/2 max-w-2xl py-5 md:py-10 lg:py-24 text-center md:text-left") ]
                [ Html.text description ]
                ]
            ]
            ]

