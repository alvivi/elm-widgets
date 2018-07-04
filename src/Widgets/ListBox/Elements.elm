module Widgets.ListBox.Elements
    exposing
        ( Element
        , anyOption
        , button
        , description
        , icon
        , id
        , list
        , option
        , textButton
        , textOption
        , selectedOption
        , wrapper
        )

{-| This module contains functions to create references to the elements of the
ListBox widget. This allows us to insert custom html options, the text inside
the button, etc.

    Form.listBox { id = "my-listbox" } []
        [ (Elements.button, H.text "Button Title")
        , (Elements.option, H.text "Option One")
        , (Elements.option, H.text "Option Two")
        , (Elements.option, H.text "Option Three")
        ]

@docs Element, button, textButton, description, icon, id, list, option
@docs anyOption, selectedOption
@docs textOption, wrapper

-}

import Html.Styled as H exposing (Html)
import Widgets.ListBox.Internal.Elements as Internal


{-| Identifies each sub element of a ListBox widget.
-}
type alias Element =
    Internal.Element


{-| An option of the ListBox. This element is an alias of `option` element and
it is meant to be used by `css` and `html` attributes. For adding options to
the ListBox use the `option` element instead of this one.
-}
anyOption : Element
anyOption =
    Internal.Option { selected = False, id = "", text = "" }


{-| The selected option of the ListBox. This element is an alias of `option`
element and it is meant to be used by `css` and `html` attributes. For adding
options to the ListBox use the `option` element instead of this one.
-}
selectedOption : Element
selectedOption =
    Internal.Option { selected = True, id = "", text = "" }


{-| The button of the ListBox.

When inserting a node tagged as button it will be added as children in the
button element.

When adding style to a button element it will be added to the button itself.

-}
button : Element
button =
    Internal.Button


{-| The description of the ListBox. By default the description is set as an ARIA
attribute unless the `descriptionLabel` is set. When the description is shown,
we can use `css` and `html` attributes with this elements to customize this
element. Also, we can add custom description node.
-}
description : Element
description =
    Internal.Description


{-| The icon of a ListBox.

When inserting a node tagged as icon it will be added over the ListBox button,
using an `div` container with an `absolute` position.

When adding style to a control with `icon` it will add the style the container
of the icon. Note that this style does not have any effect if we do not provide
any icon node.

-}
icon : Element
icon =
    Internal.Icon


{-| Given a base id of a ListBox and an element, returns the id that identifies
that element.
-}
id : String -> Element -> String
id base subElement =
    case subElement of
        Internal.Button ->
            base ++ "__button"

        Internal.Description ->
            base ++ "__desc"

        Internal.Icon ->
            base ++ "__icon"

        Internal.List ->
            base ++ "__list"

        Internal.Option { id } ->
            base ++ "__opt__" ++ id

        Internal.Wrapper ->
            base


{-| The list that contains all options of the ListBox. Use `css` to add your own
custom style or `html` to set custom html attributes.
-}
list : Element
list =
    Internal.List


{-| An option of the ListBox.

When inserting a node tagged as option it will be added as children in option
list. For adding custom html attributes or css to options use `anyOption`.

-}
option : { selected : Bool, text : String, id : String } -> Element
option =
    Internal.Option


{-| A helper for creating simple button titles.

    Form.listBox { id = "my-listbox" } []
        [ Elements.textButton "Button Title",
        , (Elements.option, H.text "Option One")
        , (Elements.option, H.text "Option Two")
        , (Elements.option, H.text "Option Three")
        ]

-}
textButton : String -> ( Element, Html msg )
textButton text =
    ( Internal.Button, H.text text )


{-| A helper for creating options with a text title.

    Form.listBox { id = "my-listbox" } []
        [ (Elements.button, H.text "Button Title")
        , Elements.textOption { selected = True, text = "Option one", id = "one" }
        , Elements.textOption { selected = False, text = "Option two", id = "two" }
        , Elements.textOption { selected = False, text = "Option three", id = "three" }
        ]

-}
textOption : { selected : Bool, text : String, id : String } -> ( Element, Html msg )
textOption data =
    ( Internal.Option data, H.text data.text )


{-| The wrapper or the parent node that contains all elements of ListBox
widget. Use `css` to add your own custom style or `html` to set custom html
attributes.
-}
wrapper : Element
wrapper =
    Internal.Wrapper
