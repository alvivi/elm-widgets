module Widgets.Dialog.Internal.Attributes
    exposing
        ( Attribute
            ( Batch
            , Css
            , Html
            , Open
            , TitleHidden
            )
        )

import Css exposing (Style)
import Widgets.Dialog.Internal.Elements as Elements exposing (Element)
import Html.Styled as H


type Attribute msg
    = Batch (List (Attribute msg))
    | Css Element Style
    | Html Element (List (H.Attribute msg))
    | Open
    | TitleHidden
