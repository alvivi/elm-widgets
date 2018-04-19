module Widgets.Normalize exposing (snippets)

{-| Snippets for normalize browser styling. You should use this snippets with
Css.Foreign at the beginning of your content. Here is an example:

    view : Model -> Html Msg
    view model =
        Html.main_ []
            [ Css.Foreign.global Widgets.Normalize.snippets
            , Html.text "My Content"
            ]

The styles are based on [Normalize](https://necolas.github.io/normalize.css/)
8.0.0. Notable changes:

  - Use of `border-box` and `box-sizing` everywhere.
  - Make images not selectable by default.
  - Disable focus outline everywhere.
  - Disable forced focus outline in select for Firefox.

@docs snippets

-}

import Css exposing (property)
import Css.Foreign exposing (Snippet, selector)


{-| Browser normalization snippets. Use this with Css.Foreign functions.
-}
snippets : List Snippet
snippets =
    [ selector "html"
        [ property "line-height" "1.15"
        , property "-webkit-text-size-adjust" "100%"
        , property "box-sizing" "border-box"
        ]
    , selector "*, *:before, *:after"
        [ property "box-sizing" "inherit"
        ]
    , selector "body"
        [ property "margin" "0"
        ]
    , selector "h1"
        [ property "font-size" "2em"
        , property "margin" "0.67em 0"
        ]
    , selector "hr"
        [ property "height" "0"
        , property "overflow" "visible"
        ]
    , selector "pre"
        [ property "font-family" "monospace, monospace"
        , property "font-size" "1em"
        ]
    , selector "a"
        [ property "background-color" "transparent"
        ]
    , selector "abbr[title]"
        [ property "border-bottom" "none"
        , property "text-decoration" "underline"
        , property "text-decoration" "underline dotted"
        ]
    , selector "b, strong"
        [ property "font-weight" "bolder"
        ]
    , selector "code, kbd, samp"
        [ property "font-family" "monospace, monospace"
        , property "font-size" "1em"
        ]
    , selector "small"
        [ property "font-size" "80%"
        ]
    , selector "sub, sup"
        [ property "font-size" "75%"
        , property "line-height" "0"
        , property "position" "relative"
        , property "vertical-align" "baseline"
        ]
    , selector "sub"
        [ property "bottom" "-0.25em"
        ]
    , selector "sup"
        [ property "top" "-0.5em"
        ]
    , selector "img"
        [ property "border-style" "none"
        , property "-webkit-user-select" "none"
        , property "-khtml-user-select" "none"
        , property "-moz-user-select" "none"
        , property "-o-user-select" "none"
        , property "user-select" "none"
        , property "-moz-user-drag" "none"
        , property "-webkit-user-drag" "none"
        , property "user-drag" "none"
        ]
    , selector "button, input, optgroup, select, textarea"
        [ property "font-family" "inherit"
        , property "font-size" "100%"
        , property "line-height" "1.15"
        , property "margin" "0"
        ]
    , selector "button, input"
        [ property "overflow" "visible"
        ]
    , selector "button, select"
        [ property "text-transform" "none"
        ]
    , selector "button, [type=\"button\"], [type=\"reset\"], [type=\"submit\"]"
        [ property "-webkit-appearance" "button"
        ]
    , selector "button::-moz-focus-inner, [type=\"button\"]::-moz-focus-inner, [type=\"reset\"]::-moz-focus-inner, [type=\"submit\"]::-moz-focus-inner"
        [ property "border-style" "none"
        , property "padding" "0"
        ]
    , selector "button:-moz-focusring, [type=\"button\"]:-moz-focusring, [type=\"reset\"]:-moz-focusring, [type=\"submit\"]:-moz-focusring"
        [ property "outline" "1px dotted ButtonText"
        ]
    , selector "fieldset"
        [ property "padding" "0.35em 0.75em 0.625em"
        ]
    , selector "legend"
        [ property "color" "inherit"
        , property "display" "table"
        , property "max-width" "100%"
        , property "padding" "0"
        , property "white-space" "normal"
        ]
    , selector "progress"
        [ property "vertical-align" "baseline"
        ]
    , selector "textarea"
        [ property "overflow" "auto"
        ]
    , selector "[type=\"checkbox\"], [type=\"radio\"]"
        [ property "padding" "0"
        ]
    , selector "[type=\"number\"]::-webkit-inner-spin-button, [type=\"number\"]::-webkit-outer-spin-button"
        [ property "height" "auto"
        ]
    , selector "[type=\"search\"]"
        [ property "-webkit-appearance" "textfield"
        , property "outline-offset" "-2px"
        ]
    , selector "[type=\"search\"]::-webkit-search-decoration"
        [ property "-webkit-appearance" "none"
        ]
    , selector "::-webkit-file-upload-button"
        [ property "-webkit-appearance" "button"
        , property "font" "inherit"
        ]
    , selector "details"
        [ property "display" "block"
        ]
    , selector "summary"
        [ property "display" "list-item"
        ]
    , selector "template"
        [ property "display" "none"
        ]
    , selector "[hidden]"
        [ property "display" "none"
        ]
    , selector "*:focus"
        [ property "outline" "none"
        ]
    , selector "select:-moz-focusring"
        [ property "color" "transparent !important"
        , property "text-shadow" "0 0 0 #000 !important"
        ]
    , selector "select option:not(:checked)"
        [ property "color" "black"
        ]
    , selector "select option:disabled"
        [ property "color" "grey !important"
        ]
    ]
