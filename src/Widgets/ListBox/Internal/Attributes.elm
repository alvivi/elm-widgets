module Widgets.ListBox.Internal.Attributes
    exposing
        ( Attribute
            ( Batch
            , ButtonAttribute
            , Css
            , DescriptionLabel
            , Expanded
            , Html
            , OnOptionClick
            , Placeholder
            , WhenHasIcon
            )
        )

import Css exposing (Style)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)
import Html.Styled as H
import Widgets.Form.Attributes as Form


type Attribute msg
    = Batch (List (Attribute msg))
    | ButtonAttribute (Form.Attribute msg)
    | Css Element Style
    | DescriptionLabel
    | Expanded
    | Html Element (List (H.Attribute msg))
    | OnOptionClick (String -> msg)
    | Placeholder String
    | WhenHasIcon (List (Attribute msg))
