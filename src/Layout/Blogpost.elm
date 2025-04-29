module Layout.Blogpost exposing
    ( viewBlogpost
    , viewListItem
    , viewPostList
    )

import Content.Blogpost exposing (Blogpost, Metadata, Status(..), TagWithCount)
import Date
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Extra
import Layout.Markdown as Markdown
import Route



-- VIEW


authorImages : List { a | image : String } -> Html msg
authorImages authors =
    List.map
        (\{ image } ->
            Html.img
                [ Attrs.alt "avatar"
                , Attrs.attribute "loading" "lazy"
                , Attrs.width 38
                , Attrs.height 38
                , Attrs.attribute "decoding" "async"
                , Attrs.attribute "data-nimg" "1"
                , Attrs.class "h-12 w-12 rounded-full hidden sm:block"
                , Attrs.src image
                ]
                []
        )
        authors
        |> Html.div [ Attrs.class "flex -space-x-2" ]


viewBlogpost : Blogpost -> Html msg
viewBlogpost { metadata, body, previousPost, nextPost } =
    let
        bottomLink slug title =
            Route.link
                [ Attrs.class "text-yellow-500  hover:text-green-500" ]
                [ Html.text title ]
                (Route.Blog__Slug_ { slug = slug })

        previous =
            previousPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "sm:col-start-1 flex flex-col mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Older post" ]
                            , "← " ++ title |> bottomLink slug
                            ]
                    )

        next =
            nextPost
                |> Html.Extra.viewMaybe
                    (\{ title, slug } ->
                        Html.div [ Attrs.class "sm:col-start-2 flex flex-col sm:text-right mt-4 xl:mt-8" ]
                            [ Html.span [] [ Html.text "Newer post" ]
                            , title ++ " →" |> bottomLink slug
                            ]
                    )

        header =
            Html.div
                [ Attrs.class "max-w-[65ch] m-auto space-y-1 xl:text-xl"
                ]
                [ Html.Extra.viewMaybe
                    (\imagePath ->
                        Html.div
                            [ Attrs.class "w-full"
                            ]
                            [ Html.div
                                [ Attrs.class "relative mt-6 -mx-6 md:-mx-8 2xl:-mx-24"
                                ]
                                [ Html.div
                                    [ Attrs.class "aspect-[2/1] w-full relative"
                                    ]
                                    [ Html.img
                                        [ Attrs.alt metadata.title
                                        , Attrs.attribute "loading" "lazy"
                                        , Attrs.attribute "decoding" "async"
                                        , Attrs.attribute "data-nimg" "fill"
                                        , Attrs.class "object-cover"
                                        , Attrs.attribute "sizes" "100vw"
                                        , Attrs.style "position" "absolute"
                                        , Attrs.style "height" "100%"
                                        , Attrs.style "width" "100%"
                                        , Attrs.style "inset" "0px"
                                        , Attrs.src imagePath
                                        ]
                                        []
                                    ]
                                ]
                            ]
                    )
                    metadata.image
                ]
        postTitle =
            Html.h1
                [ Attrs.class "text-3xl font-extrabold leading-9 tracking-tight sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                ]
                [ Route.Blog__Slug_ { slug = metadata.slug }
                    |> Route.link
                        [ Attrs.class "text-yellow-500 hover:underline decoration-green-500"
                        ]
                        [ Html.text metadata.title ]
                ]
    in
    Html.div [Attrs.class "container mx-auto px-8 py-50 items-center"]
        [ header
        , postTitle
        -- , Html.Extra.viewMaybe
        --     (\description ->
        --         Html.div
        --             [ Attrs.class "prose-p:my-4 prose lg:prose-xl text-black bg-white dark:text-white dark:bg-black" ]
        --             [ Html.p [ Attrs.class "font-bold" ] [ Html.text description ] ]
        --     )
        --     metadata.description
        , Html.article
            [ Attrs.class "prose lg:prose-xl text-white mt-8" ]
            (Markdown.blogpostToHtml body)
        , Html.div
            [ Attrs.class "mt-8 grid grid-cols-1 text-sm font-medium sm:grid-cols-2 sm:text-base bottom-0" ]
            [ previous, next ]
        ]


viewPublishedDate : Status -> Html msg
viewPublishedDate status =
    case status of
        Draft ->
            Html.span
                [ Attrs.class "leading-6 "
                ]
                [ Html.text "Draft"
                ]

        PublishedWithDate date ->
            Html.dl []
                [ Html.dt
                    [ Attrs.class "sr-only"
                    ]
                    [ Html.text "Published on" ]
                , Html.dd
                    [ Attrs.class "leading-6 "
                    ]
                    [ Html.time
                        [ Attrs.datetime <| Date.toIsoString date
                        ]
                        [ Html.text <| Date.format "d. MMM YYYY" date ]
                    ]
                ]

        Published ->
            Html.Extra.nothing


viewBlogpostMetadata : Metadata -> Html msg
viewBlogpostMetadata metadata =
    Html.article
        [ Attrs.class "space-y-2 flex flex-col xl:space-y-0"
        ]
        [ viewPublishedDate metadata.status
        , Html.div
            [ Attrs.class "space-y-3"
            ]
            [ Html.div []
                [ Html.h2
                    [ Attrs.class "text-2xl font-bold leading-8 tracking-tight"
                    ]
                    [ Route.Blog__Slug_ { slug = metadata.slug }
                        |> Route.link
                            [ Attrs.class " hover:underline decoration-green-600"
                            ]
                            [ Html.text metadata.title ]
                    ]
                ]
            , Html.Extra.viewMaybe
                (\description ->
                    Html.div
                        [ Attrs.class "prose max-w-none "
                        ]
                        [ Html.text description ]
                )
                metadata.description
            ]
        ]


viewListItem : Metadata -> Html.Html msg
viewListItem metadata =
    Html.article [ Attrs.class "my-12 " ]
        [ Html.div
            [ Attrs.class "space-y-2 xl:grid xl:grid-cols-4 xl:items-baseline xl:space-y-0"
            ]
            [ viewPublishedDate metadata.status
            , Html.div
                [ Attrs.class "space-y-5 xl:col-span-3"
                ]
                [ Html.div
                    [ Attrs.class "space-y-6"
                    ]
                    [ Html.div [ Attrs.class "space-y-4 xl:space-y-2" ]
                        [ Html.h2
                            [ Attrs.class "text-2xl font-bold leading-8 tracking-tight"
                            ]
                            [ Route.Blog__Slug_ { slug = metadata.slug }
                                |> Route.link
                                    [ Attrs.class "text-yellow-500 hover:underline decoration-green-500 "
                                    ]
                                    [ Html.text metadata.title ]
                            ]
                        ]
                    , Html.Extra.viewMaybe
                        (\description ->
                            Html.div
                                [ Attrs.class "prose text-xl max-w-none bg-white dark:bg-black dark:text-white"
                                ]
                                [ Html.text description ]
                        )
                        metadata.description
                    ]
                , Html.div
                    [ Attrs.class "text-base font-medium leading-6"
                    ]
                    [ Route.Blog__Slug_ { slug = metadata.slug }
                        |> Route.link
                            [ Attrs.class "text-yellow-500  hover:text-green-500 "
                            , Attrs.attribute "aria-label" ("Read more about \"" ++ metadata.title ++ "\"")
                            ]
                            [ Html.text "Read more →" ]
                    ]
                ]
            ]
        ]


viewPostList : List Metadata -> Maybe TagWithCount -> List (Html msg)
viewPostList metadata selectedTag =
    let
        header =
            case selectedTag of
                Just tag ->
                    Html.h1
                        [ Attrs.class "sm:hidden text-3xl font-extrabold leading-9 tracking-tight  sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                        ]
                        [ Html.text <| tag.title ]

                Nothing ->
                    Html.h1
                        [ Attrs.class "sm:hidden text-3xl font-extrabold leading-9 tracking-tight  sm:text-4xl sm:leading-10 md:text-6xl md:leading-14"
                        ]
                        [ Html.text "All Posts" ]

        allPostsLink =
            case selectedTag of
                Just _ ->
                    Route.Blog
                        |> Route.link
                            []
                            [ Html.h3
                                [ Attrs.class " hover:text-green-500 font-bold uppercase"
                                ]
                                [ Html.text "All Posts" ]
                            ]

                Nothing ->
                    Html.h3
                        [ Attrs.class "text-yellow-500 font-bold uppercase"
                        ]
                        [ Html.text "All Posts" ]
    in
    [ Html.div [ Attrs.class "pb-6 pt-6" ] [ header ]
    , Html.div [ Attrs.class "flex sm:space-x-2 md:space-x-12" ]
        [ Html.div [ Attrs.class "hidden max-h-screen h-full sm:flex flex-wrap   shadow-md pt-5 rounded min-w-[280px] max-w-[280px] overflow-auto" ]
            [ Html.div
                [ Attrs.class "py-4 px-6"
                ]
                [ allPostsLink
                ]
            ]
        , Html.div [] [ Html.ul [] <| List.map (\article -> Html.li [ Attrs.class "py-5" ] [ viewBlogpostMetadata article ]) metadata ]
        ]
    ]
