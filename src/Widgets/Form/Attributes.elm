module Widgets.Form.Attributes
    exposing
        ( Attribute
        , autocomplete
        , batch
        , css
        , descriptionLabel
        , focused
        , onBlur
        , onFocus
        , onInput
        , placeholder
        , required
        , value
        , whenFocused
        )

import Css exposing (Style)
import Widgets.Form.Elements exposing (Element)
import Widgets.Form.Internal.Attributes as A


type alias Attribute msg =
    A.Attribute msg


autocomplete : String -> Attribute msg
autocomplete =
    A.Autocomplete


batch : List (Attribute msg) -> Attribute msg
batch =
    A.Batch


css : Element -> List Style -> Attribute msg
css element style =
    A.Css element <| Css.batch style


descriptionLabel : Attribute msg
descriptionLabel =
    A.DescriptionLabel


focused : Attribute msg
focused =
    A.Focused


onBlur : msg -> Attribute msg
onBlur =
    A.OnBlur


onFocus : msg -> Attribute msg
onFocus =
    A.OnFocus


onInput : (String -> msg) -> Attribute msg
onInput =
    A.OnInput


placeholder : String -> Attribute msg
placeholder =
    A.Placeholder


required : Attribute msg
required =
    A.Required


value : String -> Attribute msg
value =
    A.Value


whenFocused : List (Attribute msg) -> Attribute msg
whenFocused =
    A.WhenFocused
