module Widgets.Form.Internal.Attributes
    exposing
        ( Attribute
            ( Autocomplete
            , Batch
            , Css
            , DescriptionLabel
            , Disabled
            , Error
            , Focused
            , Html
            , OnBlur
            , OnFocus
            , OnInput
            , Placeholder
            , Required
            , Value
            , WhenErred
            , WhenFocused
            , WhenHasIcon
            )
        )

import Css exposing (Style)
import Html.Styled as H
import Widgets.Form.Elements exposing (Element)


type Attribute msg
    = Autocomplete String
    | Batch (List (Attribute msg))
    | Css Element Style
    | DescriptionLabel
    | Disabled
    | Error String
    | Focused
    | Html Element (List (H.Attribute msg))
    | OnBlur msg
    | OnFocus msg
    | OnInput (String -> msg)
    | Placeholder String
    | Required
    | Value String
    | WhenErred (List (Attribute msg))
    | WhenFocused (List (Attribute msg))
    | WhenHasIcon (List (Attribute msg))
