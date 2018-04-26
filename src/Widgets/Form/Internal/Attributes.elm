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
            , OnBlur
            , OnFocus
            , OnInput
            , Placeholder
            , Required
            , Value
            , WhenFocused
            , WhenHasIcon
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
    | Error String
    | Focused
    | OnBlur msg
    | OnFocus msg
    | OnInput (String -> msg)
    | Placeholder String
    | Required
    | Value String
    | WhenFocused (List (Attribute msg))
    | WhenHasIcon (List (Attribute msg))
