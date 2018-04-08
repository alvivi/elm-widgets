module Docs
    exposing
        ( markdown
        , toHtml
        )

import Css
import Css as C
import Css.Foreign as C
import Html
import Html.Styled
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Markdown
import Widgets.Normalize as Normalize


type Doc
    = Markdown String


markdown : String -> Doc
markdown =
    Markdown


toHtml : List Doc -> Html.Html msg
toHtml docs =
    H.toUnstyled <|
        H.div []
            [ externalFonts
            , C.global Normalize.snippets
            , C.global
                [ C.everything
                    [ C.fontFamilies [ "Open Sans", "sans-serif" ]
                    , C.fontSize <| Css.em 1.02
                    ]
                , C.h1
                    [ C.fontWeight <| C.int 300
                    ]
                , C.strong
                    [ C.fontStyle C.normal
                    , C.fontWeight <| C.int 600
                    ]
                ]
            , H.section
                [ H.css
                    [ C.margin2 C.zero C.auto
                    , C.maxWidth <| C.px 800
                    ]
                ]
                (List.map docToHtml docs)
            ]


docToHtml : Doc -> Html msg
docToHtml doc =
    case doc of
        Markdown content ->
            Html.Styled.fromUnstyled <| Markdown.toHtml [] content


externalFonts : Html msg
externalFonts =
    H.node "style"
        []
        [ H.text """
                @import url('https://fonts.googleapis.com/css?family=Open+Sans:300,600');
                @import url('https://fonts.googleapis.com/css?family=Fira+Mono');
              """
        ]
