module Widgets.ListBox.Attributes
    exposing
        ( Attribute
        , css
        , html
        )

{-| Attributes for ListBox widgets.

@docs Attribute


# Properties

@docs css, html

-}

import Css exposing (Style)
import Html.Styled as H
import Widgets.ListBox.Internal.Attributes as A
import Widgets.ListBox.Internal.Elements exposing (Element)


{-| A Form control attribute
-}
type alias Attribute msg =
    A.Attribute msg


{-| Sets custom css for an Element of the ListBox widget.
-}
css : Element -> List Style -> Attribute msg
css element style =
    A.Css element <| Css.batch style


{-| Sets a custom set of HTML attributes to an Element of the ListBox widget.
-}
html : Element -> List (H.Attribute msg) -> Attribute msg
html =
    A.Html
