module Widgets.MenuButton.Elements exposing (menuItem, menuLink)

import Html.Styled as H exposing (Html, Attribute)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Role as Role
import KeywordList as K
import Widgets.ListBox.Elements as ListBox exposing (Element)


menuItem : { id : String, text : String } -> List (Attribute msg) -> List (Html msg) -> ( Element, Html msg )
menuItem { id, text } attrs contents =
    ( ListBox.option { id = id, selected = False, text = text }
    , H.a
        (K.fromMany
            [ K.many attrs
            , K.one <| Aria.role Role.Menuitem
            ]
        )
        contents
    )


menuLink : { id : String, text : String, href : String } -> List (Attribute msg) -> ( Element, Html msg )
menuLink { id, text, href } attrs =
    menuItem { id = id, text = text }
        (K.fromMany
            [ K.many attrs
            , K.one <| H.href href
            ]
        )
        [ H.text text ]
