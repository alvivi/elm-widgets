module Widgets.Form.Elements
    exposing
        ( Element
        , control
        , description
        , error
        , icon
        , label
        , option
        )

{-| This module expose functions to create references to the elements of the
controls. This allows us to insert custom html elements into the controls or
add custom css to them.

For adding custom style to some parts (elements) of a control we use the
attribute `css`:

    Form.email { id = "my-email-input", description = "your email" }
        [ Attributes.css Elements.label
            [ Css.backgroundColor Color.green
            ]
        ]
        []

To insert custom html elements into a control we add them to the last parameter
of a control:

    Form.email { id = "my-email-input", description = "A description" }
        []
        [ ( Elements.description
          , Html.text "My custom description"
          )
        , ( Elements.icon
          , Html.img [] []
          )
        ]

@docs Element, control, description, error, icon, label

-}

import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Widgets.Form.Internal.Elements as Internal


{-| Identifies each sub element of a Form control.
-}
type alias Element =
    Internal.Element


{-| The control itself. The `input` element for an email control or the
`button` element for a button control.

When inserting a node tagged as control it will be added as child of the input
node of the control (usually `input`, `textarea`, `select`, etc).

When adding style to a control it will be added to the main control element.

-}
control : Element
control =
    Internal.Control


{-| The description of a control.

When inserting a node tagged as description it will replace the description
text provided by `descriptionLabel` attribute.

When adding style to a control with `description` it will add the style the
default text provided by `descriptionLabel`. This style is ignored if a custom
description node is provided.

-}
description : Element
description =
    Internal.Description


{-| An error linked to a control.

When using an error node it will appear below the control, in a div wrapper.
Adding an error node will mark the control as invalid. `error` attributes will
be ignored when an error node is provided.

When adding style to a control with `error` it will add the style the wrapper
of the error element.

-}
error : Element
error =
    Internal.Error


{-| The icon of a control.

When inserting a node tagged as icon it will be added over the control, using
an `div` container with an `absolute` position.

When adding style to a control with `icon` it will add the style the
the container of the icon. Note that this style does not have any effect if
we do not provide any icon node. `position` is set to `absolute` by default but
we can override this setting.

-}
icon : Element
icon =
    Internal.Icon


{-| The label (or wrapper) of a control.

`label` is ignored when used as custom node.

When adding style to a control with `label` it will add the style the
label node of the control. This is usually the wrapper or the parent of the
whole control.

-}
label : Element
label =
    Internal.Label


{-| A helper useful for creating simple options for select controls.

    Form.select { id = "my-select", description = "A description" }
        []
        [ Elements.option { selected = True, text = "One", value = "1" }
        , Elements.option { selected = True, text = "Two", value = "2" }
        , Elements.option { selected = True, text = "Three", value = "1" }
        , Elements.option { selected = True, text = "Over 9000", value = "9001" }
        ]

-}
option : { selected : Bool, text : String, value : String } -> ( Element, Html msg )
option { selected, text, value } =
    ( Internal.Control
    , H.option [ H.selected selected, H.value value ] [ H.text text ]
    )
