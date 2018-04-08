module Widgets.Form.Elements exposing (Element(..))

-- Input represent the form control, it can be the input tag, or textarea,
-- select, etc. Note that no children nodes are allowed in input tag.


type Element
    = Input
    | Label
