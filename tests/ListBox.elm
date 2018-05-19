module ListBox exposing (..)

import Expect
import Helpers
import Html
import Html.Attributes as Html
import Html.Styled.Attributes as H
import Test as T exposing (Test)
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.ListBox as Widgets
import Widgets.ListBox.Attributes as ListBox
import Widgets.ListBox.Elements as ListBox
import Widgets.ListBox.Internal.Elements as ListBox


elements : Test
elements =
    T.describe "ListBox Widget elements"
        [ T.test "Wrapper element has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.id "foobar" ]
        , T.test "Button element has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.Button ]
        , T.test "List element has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.List ]
        ]


attributes : Test
attributes =
    T.describe "ListBox Widget attributes"
        [ T.test "`html ListBox.button` adds custom attributes to the button" <|
            \() ->
                Widgets.listBox { id = "id" }
                    [ ListBox.html ListBox.button
                        [ H.required True
                        ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        ]


nodes : Test
nodes =
    T.describe "ListBox Widget custom nodes"
        [ T.test "Adds button children nodes" <|
            \() ->
                Widgets.listBox { id = "id" } [] [ ListBox.textButton "foobar" ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Adds options children nodes in order" <|
            \() ->
                Widgets.listBox { id = "id" }
                    []
                    [ ListBox.textOption "first"
                    , ListBox.textOption "second"
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.findAll [ S.tag "li" ]
                    |> Expect.all
                        [ Q.first >> Q.contains [ Html.text "first" ]
                        , Q.index 1 >> Q.contains [ Html.text "second" ]
                        ]
        ]
