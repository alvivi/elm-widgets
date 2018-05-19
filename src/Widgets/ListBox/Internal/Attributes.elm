module Widgets.ListBox.Internal.Attributes
    exposing
        ( Attribute
            ( Css
            , DescriptionLabel
            , Expanded
            , Html
            , Placeholder
            )
        )

import Css exposing (Style)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)
import Html.Styled as H


type Attribute msg
    = Css Element Style
    | DescriptionLabel
    | Expanded
    | Html Element (List (H.Attribute msg))
    | Placeholder String
