module Dialog exposing (..)

import Expect as E
import Helpers
import Html.Attributes as Html
import Html.Styled.Attributes as H
import Test as T exposing (Test)
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.Dialog as Widgets
import Widgets.Dialog.Attributes as Dialog
import Widgets.Dialog.Elements as Dialog


dialog : Test
dialog =
    T.describe "Dialog Widget"
        [ T.test "The window element is surround of tab resets" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.children [ S.tag "div" ]
                    |> E.all
                        [ Q.index 0 >> Q.has [ S.attribute <| Html.tabindex 0 ]
                        , Q.index 1 >> Q.has [ S.id <| Dialog.id "foo" Dialog.window ]
                        , Q.index 2 >> Q.has [ S.attribute <| Html.tabindex 0 ]
                        ]
        ]


backdrop : Test
backdrop =
    T.describe "Dialog.Backdrop element"
        [ T.test "Adds custom attributes" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.html Dialog.backdrop [ H.required True ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.required True ]
        ]


window : Test
window =
    T.describe "Dialog.Window element"
        [ T.test "Has a dialog role" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.window ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "dialog" ]
        , T.test "Has `aria-modal` set to true" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.attribute "aria-modal" "true" ]
        , T.test "Adds custom attributes" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.html Dialog.window [ H.required True ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.window ]
                    |> Q.has [ S.attribute <| Html.required True ]
        ]
