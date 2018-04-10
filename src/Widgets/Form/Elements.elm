module Widgets.Form.Elements
    exposing
        ( Element
            ( Description
            , Input
            , Label
            )
        )

-- Input represent the form control, it can be the input tag, or textarea,
-- select, etc. Note that no children nodes are allowed in input tag.


type Element
    = Description
    | Input
    | Label
