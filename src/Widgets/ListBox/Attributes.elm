module Widgets.ListBox.Attributes
    exposing
        ( Attribute
        , batch
        , buttonAttributes
        , css
        , descriptionLabel
        , expanded
        , html
        , onOptionClick
        , placeholder
        , whenExpanded
        , whenHasIcon
        )

{-| Attributes for ListBox widgets.

@docs Attribute


# Properties

@docs batch, buttonAttributes, css, descriptionLabel, expanded, html, onOptionClick, placeholder


# Attribute Modifiers

@docs whenExpanded, whenHasIcon

-}

import Css exposing (Style)
import Html.Styled as H
import Widgets.ListBox.Internal.Attributes as A
import Widgets.ListBox.Internal.Elements exposing (Element)
import Widgets.Form.Attributes as Form


{-| A Form control attribute
-}
type alias Attribute msg =
    A.Attribute msg


{-| Group a bunch of attributes in a single one attribute.
-}
batch : List (Attribute msg) -> Attribute msg
batch =
    A.Batch


{-| Sets custom Form attributes to the button element.
-}
buttonAttributes : List (Form.Attribute msg) -> Attribute msg
buttonAttributes =
    Form.batch >> A.ButtonAttribute


{-| Sets custom css for an Element of the ListBox widget.
-}
css : Element -> List Style -> Attribute msg
css element style =
    A.Css element <| Css.batch style


{-| Show the description as text. Note that this overridden if you provide your
own custom description element.
-}
descriptionLabel : Attribute msg
descriptionLabel =
    A.DescriptionLabel


{-| Set the ListBox as expanded, showing its options and allowing the user to
choose one or several of them.
-}
expanded : Attribute msg
expanded =
    A.Expanded


{-| Sets a custom set of HTML attributes to an Element of the ListBox widget.
-}
html : Element -> List (H.Attribute msg) -> Attribute msg
html =
    A.Html


{-| Sets a event listener for click event on list options. The id of the
options is passed to the handler.
-}
onOptionClick : (String -> msg) -> Attribute msg
onOptionClick =
    A.OnOptionClick


{-| Sets a placeholder text that will be shown as the button text when no
options is selected. Note that a custom button node overrides this attribute.
-}
placeholder : String -> Attribute msg
placeholder =
    A.Placeholder


{-| Applies attributes when the ListBox is expanded an icon. Useful for building
themes.
-}
whenExpanded : List (Attribute msg) -> Attribute msg
whenExpanded =
    A.WhenExpanded


{-| Applies attributes only when the ListBox has an icon. Useful for building
themes.
-}
whenHasIcon : List (Attribute msg) -> Attribute msg
whenHasIcon =
    A.WhenHasIcon
