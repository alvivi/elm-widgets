module Widgets.Helpers.Css exposing (appearance)

import Css as C exposing (Style)


appearance : String -> Style
appearance style =
    C.batch
        [ C.property "-moz-appearance" style
        , C.property "-webkit-appearance" style
        , C.property "appearance" style
        ]
