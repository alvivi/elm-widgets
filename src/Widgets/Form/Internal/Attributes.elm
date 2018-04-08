module Widgets.Form.Internal.Attributes
    exposing
        ( Attribute
            ( Autocomplete
            , Batch
            , Css
            , DescriptionLabel
            , OnBlur
            , OnFocus
            , OnInput
            , Placeholder
            , Required
            , Value
            )
        )

import Css exposing (Style)
import Widgets.Form.Elements exposing (Element)


type Attribute msg
    = Autocomplete String
    | Batch (List (Attribute msg))
    | Css Element Style
    | DescriptionLabel
    | OnBlur msg
    | OnFocus msg
    | OnInput (String -> msg)
    | Placeholder String
    | Required
    | Value String
