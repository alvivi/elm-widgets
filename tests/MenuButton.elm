module MenuButton exposing (..)

import Helpers
import Html.Attributes as Html
import Test as T exposing (Test)
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.ListBox.Elements as ListBox
import Widgets.MenuButton as Widgets


button : Test
button =
    T.describe "Button element"
        [ T.test "aria-haspopup attribute is set" <|
            \() ->
                Widgets.menuButton { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-haspopup" "menu" ]
        , T.test "aira-controls attrtibues is set" <|
            \() ->
                Widgets.menuButton { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has
                        [ S.attribute <|
                            Html.attribute "aria-controls" <|
                                ListBox.id "foobar" ListBox.list
                        ]
        ]


list : Test
list =
    T.describe "List element"
        [ T.test "role is set to menu" <|
            \() ->
                Widgets.menuButton { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "menu" ]
        , T.test "role is set to none in option wrappers" <|
            \() ->
                Widgets.menuButton { id = "foobar", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, id = "1", text = "one" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "li" ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "none" ]
        ]
