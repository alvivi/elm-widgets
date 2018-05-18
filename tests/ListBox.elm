module ListBox exposing (..)

import Expect
import Helpers
import Html
import Test as T exposing (Test)
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.ListBox as Widgets
import Widgets.ListBox.Elements as Elements


listBox : Test
listBox =
    T.describe "ListBox Widget"
        [ T.test "Adds button children nodes" <|
            \() ->
                Widgets.listBox { id = "id" } [] [ Elements.textButton "foobar" ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Adds options children nodes in order" <|
            \() ->
                Widgets.listBox { id = "id" }
                    []
                    [ Elements.textOption "first"
                    , Elements.textOption "second"
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.findAll [ S.tag "li" ]
                    |> Expect.all
                        [ Q.first >> Q.contains [ Html.text "first" ]
                        , Q.index 1 >> Q.contains [ Html.text "second" ]
                        ]
        ]
