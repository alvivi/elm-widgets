module Widgets.Form.Internal.Elements
    exposing
        ( Element
            ( Control
            , Description
            , Error
            , Icon
            , Label
            )
        , id
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


{-| Returns an identifier as a string.
-}
id : String -> Element -> String
id base subElement =
    case subElement of
        Control ->
            base

        Description ->
            base ++ "__description"

        Error ->
            base ++ "__error"

        Icon ->
            base ++ "__icon"

        Label ->
            base ++ "__label"
