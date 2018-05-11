module Widgets.Themes.Mint exposing (button, global, input, text, select)

{-| A basic theme for the whole Widgets library. The purpose of this theme
is to be an example on how to build themes, but it can also be use for
prototyping.

You can also use this theme as a base style, and then apply your own styles.

This theme requires a css normalization base. See global for more information.


# Initialization

@docs global


# Theming Widgets

@docs button, input, select


# Theming Html Nodes

@docs text

-}

import Css as C exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Attributes as Form exposing (Attribute)
import Widgets.Form.Elements as FormElements
import Widgets.Helpers.Css as C


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


{-| Apply Mint theme to Widgets.Form button.

    Form.button [ Widgets.Themes.Mint.button ] [ Html.text "Title" ]

-}
button : Attribute msg
button =
    Form.batch
        [ Form.css FormElements.control
            [ text
            , C.backgroundColor primaryColor
            , C.border C.zero
            , C.borderRadius <| C.px 3
            , C.color backgroundColor
            , C.padding2 (C.px 11) (C.px 16)
            , C.hover
                [ C.backgroundColor highlightColor
                ]
            , C.disabled
                [ C.backgroundColor hintColor
                ]
            ]
        ]


{-| Apply Mint theme to Widgets.Form input controls.

    Form.input { id = "id" , description = "desc" , type_ = "text" }
      [ Widgets.Themes.Mint.input ] []

-}
input : Attribute msg
input =
    Form.batch
        [ Form.css FormElements.control
            [ text
            , C.backgroundColor backgroundColor
            , C.border3 (C.px 1) C.solid hintColor
            , C.borderRadius <| C.px 3
            , C.margin <| C.px 1
            , C.padding (C.px 10)
            , C.focus
                [ C.border3 (C.px 2) C.solid primaryColor
                , C.margin <| C.zero
                ]
            , C.disabled
                [ C.backgroundColor disabledBackgroundColor
                ]
            ]
        , Form.css FormElements.description
            [ text
            , C.padding <| C.px 4
            ]
        , Form.css FormElements.icon
            [ C.width <| C.px 32
            , C.height <| C.px 32
            , C.color hintColor
            , C.paddingTop <| C.px 10
            , C.paddingLeft <| C.px 12
            ]
        , Form.css FormElements.error
            [ text
            , C.color errorColor
            , C.fontStyle C.normal
            , C.paddingLeft <| C.px 2
            , C.paddingTop <| C.px 2
            ]
        , Form.whenErred
            [ Form.css FormElements.control
                [ C.border3 (C.px 1) C.solid errorColor
                ]
            ]
        , Form.whenFocused
            [ Form.css FormElements.description
                [ C.color primaryColor
                ]
            , Form.css FormElements.icon
                [ C.color primaryColor
                ]
            ]
        , Form.whenHasIcon
            [ Form.css FormElements.control
                [ C.padding4 (C.px 10) (C.px 10) (C.px 10) (C.px 42)
                ]
            , Form.whenHasType "select"
                [ Form.css FormElements.icon
                    [ C.paddingLeft C.zero
                    , C.paddingRight <| C.px 8
                    ]
                ]
            ]
        ]


{-| Apply Mint theme to Widgets.Form select control.

    Form.select { id = "id" , description = "desc" }
      [ Widgets.Themes.Mint.input ] []

-}
select : Attribute msg
select =
    -- We have to set height to avoid:
    -- https://bugzilla.mozilla.org/show_bug.cgi?id=454625
    Form.batch
        [ input
        , Form.css FormElements.control
            [ C.padding2 (C.px 0) (C.px 10)
            , C.height <| C.px <| fontSize.numericValue + 24
            ]
        , Form.whenHasIcon
            [ Form.css FormElements.control
                [ C.padding4 (C.px 0) (C.px 42) (C.px 0) (C.px 10)
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
        , C.fontSize fontSize
        ]



-- Scale


fontSize : C.Px
fontSize =
    C.px 16



-- Colors


backgroundColor : C.Color
backgroundColor =
    C.hex "#FFFFFF"


disabledBackgroundColor : C.Color
disabledBackgroundColor =
    C.hex "#FAFAFF"


errorColor : C.Color
errorColor =
    C.hex "#FC006E"


highlightColor : C.Color
highlightColor =
    C.hex "#0084FF"


hintColor : C.Color
hintColor =
    C.hex "#CFD5D9"


primaryColor : C.Color
primaryColor =
    C.hex "#0074FF"


textColor : C.Color
textColor =
    C.hex "#2B2B2B"
