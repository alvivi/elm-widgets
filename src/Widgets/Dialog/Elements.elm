module Widgets.Dialog.Elements exposing (Element, backdrop, id, title, window)

{-| A module containing functions to create references to the elements of a
Dialog widget.

@docs Element, backdrop, id, title, window

-}

import Widgets.Dialog.Internal.Elements as Internal


{-| Identifies each sub element of a Dialog widget.
-}
type alias Element =
    Internal.Element


{-| The element that overlaps the external content when the dialog is active.
Typically this element will visually obscure that content.
-}
backdrop : Element
backdrop =
    Internal.Backdrop


{-| The title of dialog.
-}
title : Element
title =
    Internal.Title


{-| The main window of the dialog.
-}
window : Element
window =
    Internal.Window


{-| Given a base id of a Dialog and an element, returns the id that identifies
that element.
-}
id : String -> Element -> String
id base subElement =
    case subElement of
        Internal.Backdrop ->
            base ++ "__backdrop"

        Internal.Title ->
            base ++ "__title"

        Internal.Window ->
            base ++ "__window"
