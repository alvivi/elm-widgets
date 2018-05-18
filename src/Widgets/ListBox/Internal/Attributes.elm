module Widgets.ListBox.Internal.Attributes
    exposing
        ( Attribute
            ( Css
            , Html
            )
        )

import Css exposing (Style)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)
import Html.Styled as H


type Attribute msg
    = Css Element Style
    | Html Element (List (H.Attribute msg))
