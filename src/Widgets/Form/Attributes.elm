module Widgets.Form.Attributes
    exposing
        ( Attribute
        , autocomplete
        , batch
        , css
        , descriptionLabel
        , disabled
        , focused
        , onBlur
        , onFocus
        , onInput
        , placeholder
        , required
        , value
        , whenFocused
        )

{-| Attributes for Form controls.

@docs Attribute


# Properties

@docs autocomplete, descriptionLabel, disabled, placeholder, required, value


# Events

@docs onBlur, onFocus, onInput


# State

@docs focused, whenFocused


# Helpers

@docs batch, css

-}

import Css exposing (Style)
import Widgets.Form.Elements exposing (Element)
import Widgets.Form.Internal.Attributes as A


{-| A Form control attribute
-}
type alias Attribute msg =
    A.Attribute msg


{-| Set the type of autocomplete for the control. Valid options can be found
[here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#autocomplete).
All controls exposed in Widgets.Form but input set this value for you.
-}
autocomplete : String -> Attribute msg
autocomplete =
    A.Autocomplete


{-| Batch several attributes together. Useful for making you own custom
controls.
-}
batch : List (Attribute msg) -> Attribute msg
batch =
    A.Batch


{-| Sets custom css for an Element of the controls.
-}
css : Element -> List Style -> Attribute msg
css element style =
    A.Css element <| Css.batch style


{-| Show the description as text. Note that this overridden if you provide your
own custom Label element.
-}
descriptionLabel : Attribute msg
descriptionLabel =
    A.DescriptionLabel


{-| Sets the control as disabled.
-}
disabled : Attribute msg
disabled =
    A.Disabled


{-| Sets the control as focused
-}
focused : Attribute msg
focused =
    A.Focused


{-| Notifies when the control loose the focus
-}
onBlur : msg -> Attribute msg
onBlur =
    A.OnBlur


{-| Notifies when the control is focused
-}
onFocus : msg -> Attribute msg
onFocus =
    A.OnFocus


{-| Notifies when the control has a new value
-}
onInput : (String -> msg) -> Attribute msg
onInput =
    A.OnInput


{-| Sets the placeholder of the control
-}
placeholder : String -> Attribute msg
placeholder =
    A.Placeholder


{-| Sets the control as required
-}
required : Attribute msg
required =
    A.Required


{-| Sets the value of the control
-}
value : String -> Attribute msg
value =
    A.Value


{-| Applies attributes only when the control is focused. You can combine this
with css to add style to some elements only when the control is focused.
-}
whenFocused : List (Attribute msg) -> Attribute msg
whenFocused =
    A.WhenFocused
