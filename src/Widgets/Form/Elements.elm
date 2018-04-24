module Widgets.Form.Elements
    exposing
        ( Element
        , description
        , icon
        , input
        , label
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

    Form.email { id = "my-email-input", description = "" }
        []
        [ ( Elements.description
          , Html.text "My custom description"
          )
        , ( Elements.icon
          , Html.img [] []
          )
        ]

@docs Element, description, icon, input, label

-}

import Widgets.Form.Internal.Elements as Internal


{-| Identifies each sub element of a Form control.
-}
type alias Element =
    Internal.Element


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


{-| The input itself of a control.

When inserting a node tagged as input it will be added as child of the input
node of the control (usually `input`, `textarea`, `select`, etc).

When adding style to a control with `input` it will add the style the
input node of the control.

-}
input : Element
input =
    Internal.Input


{-| The label (or wrapper) of a control.

`label` is ignored when used as custom node.

When adding style to a control with `label` it will add the style the
label node of the control. This is usually the wrapper or the parent of the
whole control.

-}
label : Element
label =
    Internal.Label
