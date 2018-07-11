module Widgets.Dialog.Attributes
    exposing
        ( Attribute
        , batch
        , css
        , html
        , onFocusLeavesBackward
        , onFocusLeavesForward
        , open
        , titleHidden
        )

{-| Attributes for the Dialog widget.

@docs Attribute


# Properties

@docs batch, open, css, html, titleHidden, onFocusLeavesBackward, onFocusLeavesForward

-}

import Css exposing (Style)
import Html.Styled as H
import Widgets.Dialog.Internal.Attributes as Internal
import Widgets.Dialog.Internal.Elements exposing (Element)


{-| A Form control attribute
-}
type alias Attribute msg =
    Internal.Attribute msg


{-| Group a bunch of attributes in a single one attribute.
-}
batch : List (Attribute msg) -> Attribute msg
batch =
    Internal.Batch


{-| Sets custom css for an Element of the Dialog widget.
-}
css : Element -> List Style -> Attribute msg
css element style =
    Internal.Css element <| Css.batch style


{-| Sets a custom set of HTML attributes to an Element of the ListBox widget.
-}
html : Element -> List (H.Attribute msg) -> Attribute msg
html =
    Internal.Html


{-| Set the Dialog as opened, displaying the dialog over previous content.
-}
open : Attribute msg
open =
    Internal.Open


{-| Makes the title to not appear as a content of the Dialog window. Note that
the content is still used as label (description) of the widget.
-}
titleHidden : Attribute msg
titleHidden =
    Internal.TitleHidden


{-| Sets the msg that will be sent when the focus leaves the dialog using
`shift + tab`.
-}
onFocusLeavesBackward : msg -> Attribute msg
onFocusLeavesBackward =
    Internal.OnFocusLeavesBackward


{-| Sets the msg that will be sent when the focus leaves the dialog using `tab`.
-}
onFocusLeavesForward : msg -> Attribute msg
onFocusLeavesForward =
    Internal.OnFocusLeavesForward
