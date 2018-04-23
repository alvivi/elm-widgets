module Widgets.Helpers.Css exposing (noPointerEvents)

import Css as C exposing (Style)


noPointerEvents : Style
noPointerEvents =
    C.property "pointer-events" "none"
