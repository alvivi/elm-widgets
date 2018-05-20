module Widgets.ListBox.Internal.Attributes
    exposing
        ( Attribute
            ( ButtonAttribute
            , Css
            , DescriptionLabel
            , Expanded
            , Html
            , Placeholder
            )
        )

import Css exposing (Style)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)
import Html.Styled as H
import Widgets.Form.Attributes as Form


type Attribute msg
    = ButtonAttribute (Form.Attribute msg)
    | Css Element Style
    | DescriptionLabel
    | Expanded
    | Html Element (List (H.Attribute msg))
    | Placeholder String
