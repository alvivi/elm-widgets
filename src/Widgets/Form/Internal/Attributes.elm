module Widgets.Form.Internal.Attributes
    exposing
        ( Attribute
            ( Autocomplete
            , Batch
            , Css
            , DescriptionLabel
            , Disabled
            , Focused
            , OnBlur
            , OnFocus
            , OnInput
            , Placeholder
            , Required
            , Value
            , WhenFocused
            )
        )

import Css exposing (Style)
import Widgets.Form.Elements exposing (Element)


type Attribute msg
    = Autocomplete String
    | Batch (List (Attribute msg))
    | Css Element Style
    | DescriptionLabel
    | Disabled
    | Focused
    | OnBlur msg
    | OnFocus msg
    | OnInput (String -> msg)
    | Placeholder String
    | Required
    | Value String
    | WhenFocused (List (Attribute msg))
