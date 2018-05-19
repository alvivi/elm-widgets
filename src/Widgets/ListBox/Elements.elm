module Widgets.ListBox.Elements
    exposing
        ( Element
        , button
        , description
        , option
        , textButton
        , textOption
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

@docs Element, button, textButton, description, option, textOption

-}

import Html.Styled as H exposing (Html)
import Widgets.ListBox.Internal.Elements as Internal


{-| Identifies each sub element of a ListBox widget.
-}
type alias Element =
    Internal.Element


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


{-| An option of the ListBox.

When inserting a node tagged as option it will be added as children in option
list.

Does not support styling, nor custom HTML attributes.

-}
option : Element
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
        , Elements.textOption "Option One"
        , Elements.textOption "Option Two"
        , Elements.textOption "Option Three"
        ]

-}
textOption : String -> ( Element, Html msg )
textOption text =
    ( Internal.Option, H.text text )
