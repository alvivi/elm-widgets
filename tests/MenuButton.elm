module MenuButton exposing (..)

import Helpers
import Html.Attributes as Html
import Test as T exposing (Test)
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.MenuButton as Widgets


button : Test
button =
    T.describe "Button element"
        [ T.test "haspopup attribute is set to menu " <|
            \() ->
                Widgets.menuButton { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-haspopup" "menu" ]
        ]
