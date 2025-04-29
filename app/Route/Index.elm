module Route.Index exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Content.Blogpost exposing (Metadata)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html
import Html.Attributes as Attrs
import LanguageTag.Language as Language
import LanguageTag.Region as Region
import Layout
import Layout.Blogpost
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Settings
import Shared
import UrlPath
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
view app _ =
    { title = Settings.title
    , body =
        [ heroSection
        , projectsSection
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

projectsSection =
        Html.node "section"
            [ Attrs.id "projects", Attrs.class "py-32 ", Attrs.attribute "aria-labelledby" "projects-heading" ]
            [ Html.div [ Attrs.class "container mx-auto px-8" ]
                [ Html.h2 [ Attrs.id "projects-heading", Attrs.class "text-6xl font-extrabold tracking-tighter text-center mb-32" ]
                    [ Html.text "Projects" ]
                , Html.div [ Attrs.class "flex flex-col gap-32" ]
                    [ projectCard "Capybara House" "Connecting students with tailored accommodation solutions in Dublin." "https://capybara.house" "house"
                    , projectCard "Capybara School" "Offering English courses from leading Dublin-based institutions for global learners." "https://capybara.school" "school"
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
            [ Html.div [ Attrs.class "container mx-auto px-8 text-center" ]
                [ Html.h2 [ Attrs.id "contact-heading", Attrs.class "text-6xl font-extrabold tracking-tighter mb-10" ]
                    [ Html.text "Contact" ]
                , Html.p [ Attrs.class "text-xl tracking-wide max-w-xl mx-auto mb-10" ]
                    [ Html.text "Collaborate with us." ]
                , Html.a [ Attrs.href "mailto:info@tranquera.co", Attrs.class "inline-block  border border-white px-8 py-3 text-base uppercase tracking-widest hover:bg-white hover:text-black focus:bg-white focus:text-black focus:outline-none focus:ring-2 focus:ring-white transition" ]
                    [ Html.text "Reach Out" ]
                ]
            ]
projectCard title description url type_ =
        let
            secondWordClass =
                if type_ == "house" then
                    "second-word-house transition-colors"
                else
                    "second-word-school transition-colors"

            cardContentClass =
                if type_ == "house" then
                    "card-content-house"
                else
                    "card-content-school"

            descClass =
                if type_ == "house" then
                    "description-house"
                else
                    "description-school"
        in
        Html.article []
            [ Html.a [ Attrs.href url, Attrs.attribute "target" "_blank", Attrs.class ("project-card flex items-center"), Attrs.attribute "aria-label" ("Visit " ++ title) ]
                [ Html.div [ Attrs.class (cardContentClass ++ " flex flex-col md:flex-row items-start w-full") ]
                    [ Html.h3 [ Attrs.class "text-7xl font-extrabold tracking-tighter w-full md:w-1/2 m-10" ]
                        [ Html.span [ Attrs.class "title-capybara" ] [ Html.text "Capybara" ]
                        , Html.span [ Attrs.class secondWordClass ] [ Html.text (if type_ == "house" then "House" else "School") ]
                        ]
                    , Html.p [ Attrs.class (descClass ++ " text-xl tracking-wide w-full md:w-1/2 max-w-2xl py-14") ]
                        [ Html.text description ]
                    ]
                ]
            ]

