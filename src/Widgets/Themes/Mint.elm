module Widgets.Themes.Mint exposing (global, input, text)

import Css as C exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Attributes as Form exposing (Attribute)
import Widgets.Form.Elements as Form


global : Html msg
global =
    H.div []
        [ H.node "style"
            []
            [ H.text "@import url('https://fonts.googleapis.com/css?family=Open+Sans:300');"
            ]
        ]


input : Attribute msg
input =
    Form.batch
        [ Form.css Form.Input
            [ text
            , C.border3 (C.px 1) C.solid hintColor
            , C.borderRadius <| C.px 3
            , C.margin <| C.px 1
            , C.padding2 (C.px 10) (C.px 12)
            , C.focus
                [ C.border3 (C.px 2) C.solid primaryColor
                , C.margin <| C.zero
                ]
            ]
        , Form.css Form.Description
            [ text
            , C.padding <| C.px 4
            ]
        , Form.whenFocused
            [ Form.css Form.Description
                [ C.color primaryColor
                ]
            ]
        ]


text : Style
text =
    C.batch
        [ C.color textColor
        , C.fontFamilies [ "Open Sans", "sans-serif" ]
        ]



-- Colors


hintColor : C.Color
hintColor =
    C.hex "#CFD5D9"


primaryColor : C.Color
primaryColor =
    C.hex "#0074FF"


textColor : C.Color
textColor =
    C.hex "#2B2B2B"
