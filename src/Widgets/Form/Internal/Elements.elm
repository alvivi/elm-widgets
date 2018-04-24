module Widgets.Form.Internal.Elements
    exposing
        ( Element
            ( Description
            , Icon
            , Input
            , Label
            )
        )

{-| This module provides a type for referencing each of the element which are
part of the form controls.

@docs Element

-}


{-| Identifies each sub element of a Form control.
-}
type Element
    = Description
    | Icon
    | Input
    | Label
