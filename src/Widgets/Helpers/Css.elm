module Widgets.Helpers.Css exposing (appearance, intrinsicWidth)

import Css as C exposing (Style)


appearance : String -> Style
appearance style =
    C.batch
        [ C.property "-moz-appearance" style
        , C.property "-webkit-appearance" style
        , C.property "appearance" style
        ]


intrinsicWidth : Style
intrinsicWidth =
    C.batch
        [ C.property "width" "-moz-max-content"
        , C.property "width" "-webkit-max-content"
        , C.property "width" "-o-max-content"
        , C.property "width" "max-content"
        ]
