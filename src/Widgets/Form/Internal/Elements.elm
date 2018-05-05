module Widgets.Form.Internal.Elements
    exposing
        ( Element
            ( Control
            , Description
            , Error
            , Icon
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
    = Control
    | Description
    | Error
    | Icon
    | Label
