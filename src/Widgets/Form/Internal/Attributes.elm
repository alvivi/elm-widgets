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
            , OnClick
            , OnFocus
            , OnInput
            , OnKeyUp
            , Placeholder
            , Required
            , Value
            , WhenErred
            , WhenFocused
            , WhenHasDescriptionLabel
            , WhenHasIcon
            , WhenHasType
            )
        )

import Css exposing (Style)
import Html.Styled as H
import Widgets.Form.Elements exposing (Element)
import Char exposing (KeyCode)


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
    | OnClick msg
    | OnFocus msg
    | OnInput (String -> msg)
    | OnKeyUp (KeyCode -> msg)
    | Placeholder String
    | Required
    | Value String
    | WhenErred (List (Attribute msg))
    | WhenFocused (List (Attribute msg))
    | WhenHasDescriptionLabel (List (Attribute msg))
    | WhenHasIcon (List (Attribute msg))
    | WhenHasType String (List (Attribute msg))
