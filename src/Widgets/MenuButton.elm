module Widgets.MenuButton exposing (menuButton)

{-| A [MenuButton][wai-mb] is a button that open a menu. This widgets is based on
ListBox widget and uses ListBox attributes and elements.

@docs menuButton

[wai-mb]: https://www.w3.org/TR/2017/NOTE-wai-aria-practices-1.1-20171214/#menubutton
[wai-ex]: https://www.w3.org/TR/2017/NOTE-wai-aria-practices-1.1-20171214/examples/menu-button/menu-button-links.html

-}

import Html.Styled as H exposing (Html)
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Popup as Popup
import Html.Styled.Attributes.Aria.Role as Role
import KeywordList as K
import Widgets.ListBox as Widgets
import Widgets.ListBox.Attributes as ListBox
import Widgets.ListBox.Elements as ListBox


{-| A MenuButton element.
-}
menuButton : { id : String, description : String } -> List (ListBox.Attribute msg) -> List ( ListBox.Element, Html msg ) -> Html msg
menuButton basics attrs elements =
    Widgets.listBox basics
        (K.fromMany
            [ K.many attrs
            , K.many
                [ ListBox.html ListBox.button
                    [ Aria.controls [ ListBox.id basics.id ListBox.list ]
                    , Aria.hasPopup Popup.Menu
                    ]
                , ListBox.html ListBox.list
                    [ Aria.role Role.Menu
                    ]
                , ListBox.html ListBox.anyOption
                    [ Aria.role Role.None ]
                ]
            ]
        )
        elements
