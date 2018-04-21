module Widgets.Themes.Mint exposing (global, input, text)

{-| A basic theme for the whole Widgets library. The purpose of this theme
is to be an example on how to build themes, but it can also be use for
prototyping.

You can also use this theme as a base style, and then apply your own styles.

This theme requires a css normalization base. See global for more information.


# Initialization

@docs global


# Theming Widgets

@docs input


# Theming Html Nodes

@docs text

-}

import Css as C exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Attributes as Form exposing (Attribute)
import Widgets.Form.Elements as Form


{-| Common styles needed by other parts of this theme. Use this to initialize
the theme together with Widgets.Normalize.snippets.

    view : Model -> Html Msg
    view model =
        Html.main_ []
            [ Css.Foreign.global Widgets.Normalize.snippets
            , Widgets.Themes.Mint.global
            , Html.text "My Content"
            ]

-}
global : Html msg
global =
    H.div []
        [ H.node "style"
            []
            [ H.text "@import url('https://fonts.googleapis.com/css?family=Open+Sans:300');"
            ]
        ]


{-| Apply this theme to Widgets.Form widgets. You only need to include this
attribute in any of widgets of Widgets.Form.

    Form.input { id = "id" , description = "desc" , type_ = "text" }
      [ Widgets.Themes.Mint.input ] []

-}
input : Attribute msg
input =
    Form.batch
        [ Form.css Form.Input
            [ text
            , C.border3 (C.px 1) C.solid hintColor
            , C.borderRadius <| C.px 3
            , C.margin <| C.px 1
            , C.padding2 (C.px 10) (C.px 12)
            , C.backgroundColor backgroundColor
            , C.focus
                [ C.border3 (C.px 2) C.solid primaryColor
                , C.margin <| C.zero
                ]
            , C.disabled
                [ C.backgroundColor disabledBackgroundColor
                , C.cursor C.notAllowed
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


{-| Apply a simple text styling to an Html node.

    Html.h1 [ Html.css [ Widgets.Themes.text ] ] [ H.text "My Header" ]

-}
text : Style
text =
    C.batch
        [ C.color textColor
        , C.fontFamilies [ "Open Sans", "sans-serif" ]
        ]



-- Colors


backgroundColor : C.Color
backgroundColor =
    C.hex "#FFFFFF"


disabledBackgroundColor : C.Color
disabledBackgroundColor =
    C.hex "#FAFAFF"


hintColor : C.Color
hintColor =
    C.hex "#CFD5D9"


primaryColor : C.Color
primaryColor =
    C.hex "#0074FF"


textColor : C.Color
textColor =
    C.hex "#2B2B2B"
