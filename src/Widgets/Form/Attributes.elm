module Widgets.Form.Attributes
    exposing
        ( Attribute
        , autocomplete
        , batch
        , css
        , descriptionLabel
        , disabled
        , error
        , focused
        , html
        , onBlur
        , onClick
        , onFocus
        , onInput
        , onKeyUp
        , placeholder
        , required
        , value
        , whenErred
        , whenFocused
        , whenHasDescriptionLabel
        , whenHasIcon
        , whenHasType
        )

{-| Attributes for Form controls.

@docs Attribute


# Properties

@docs autocomplete, batch, css, descriptionLabel, disabled, error, focused, html, placeholder, required, value


# Events

@docs onBlur, onClick, onFocus, onInput, onKeyUp


# Attribute Modifiers

@docs whenErred, whenFocused, whenHasDescriptionLabel, whenHasIcon, whenHasType

-}

import Char exposing (KeyCode)
import Css exposing (Style)
import Html.Styled as H
import Widgets.Form.Elements exposing (Element)
import Widgets.Form.Internal.Attributes as Internal


{-| A Form control attribute
-}
type alias Attribute msg =
    Internal.Attribute msg


{-| Set the type of autocomplete for the control. Valid options can be found
[here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#autocomplete).
All controls exposed in Widgets.Form but input set this value for you.
-}
autocomplete : String -> Attribute msg
autocomplete =
    Internal.Autocomplete


{-| Batch several attributes together. Useful for making you own custom
controls.
-}
batch : List (Attribute msg) -> Attribute msg
batch =
    Internal.Batch


{-| Sets custom css for an Element of the controls.
-}
css : Element -> List Style -> Attribute msg
css element style =
    Internal.Css element <| Css.batch style


{-| Show the description as text. Note that this overridden if you provide your
own custom Label element.
-}
descriptionLabel : Attribute msg
descriptionLabel =
    Internal.DescriptionLabel


{-| Sets the control as disabled.
-}
disabled : Attribute msg
disabled =
    Internal.Disabled


{-| Sets an error message for the control. Usually used when validating fields.
-}
error : String -> Attribute msg
error =
    Internal.Error


{-| Sets the control as focused.
-}
focused : Attribute msg
focused =
    Internal.Focused


{-| Sets a custom set of HTML attributes to an Element of the controls.
-}
html : Element -> List (H.Attribute msg) -> Attribute msg
html =
    Internal.Html


{-| Notifies when the control loose the focus.
-}
onBlur : msg -> Attribute msg
onBlur =
    Internal.OnBlur


{-| Notifies when the control is clicked.
-}
onClick : msg -> Attribute msg
onClick =
    Internal.OnClick


{-| Notifies when the control is focused.
-}
onFocus : msg -> Attribute msg
onFocus =
    Internal.OnFocus


{-| Notifies when the control has a new value.
-}
onInput : (String -> msg) -> Attribute msg
onInput =
    Internal.OnInput


{-| Notifies when the user releases a key on the keyboard while the control has
the focus.
-}
onKeyUp : (KeyCode -> msg) -> Attribute msg
onKeyUp =
    Internal.OnKeyUp


{-| Sets the placeholder of the control.
-}
placeholder : String -> Attribute msg
placeholder =
    Internal.Placeholder


{-| Sets the control as required.
-}
required : Attribute msg
required =
    Internal.Required


{-| Sets the value of the control.
-}
value : String -> Attribute msg
value =
    Internal.Value


{-| Applies attributes only when the control has an error. You can combine
this attribute with css to add style to some elements when the control has some
error.
-}
whenErred : List (Attribute msg) -> Attribute msg
whenErred =
    Internal.WhenErred


{-| Applies attributes only when the control is focused. You can combine this
attribute with css to add style to some elements when the control is focused.
-}
whenFocused : List (Attribute msg) -> Attribute msg
whenFocused =
    Internal.WhenFocused


{-| Applies attributes when the control has a description label. This can be
applied when you provide the `descriptionLabel` to a control, or adding a
custom label element.
-}
whenHasDescriptionLabel : List (Attribute msg) -> Attribute msg
whenHasDescriptionLabel =
    Internal.WhenHasDescriptionLabel


{-| Applies attributes only when the control has an icon. Useful for building
themes.
-}
whenHasIcon : List (Attribute msg) -> Attribute msg
whenHasIcon =
    Internal.WhenHasIcon


{-| Applies attributes only when the control type is equal to the provided
type. For example, the following code applies the style only when control is
an email input:

    whenHasType "email" [ Html.css [ Css.backgroundColor Color.green  ] ]

All controls have a type, even when the internal tag has not tag. That means
that we can use `"select"` for select controls, `"textarea"` for textareas, etc.

-}
whenHasType : String -> List (Attribute msg) -> Attribute msg
whenHasType =
    Internal.WhenHasType
