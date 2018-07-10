module Dialog exposing (..)

import Expect as E
import Helpers
import Html
import Html.Attributes as Html
import Html.Styled as H
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
        , T.test "A title header is added to the window by default" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.window ]
                    |> Q.children [ S.tag "h2" ]
                    |> Q.first
                    |> Q.contains [ Html.text "bar" ]
        , T.test "background is labeled by title" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has
                        [ S.attribute <|
                            Html.attribute "aria-labelledby" <|
                                Dialog.id "foo" Dialog.title
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


title : Test
title =
    T.describe "Dialog.Title element"
        [ T.test "Adds custom attributes" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.html Dialog.title [ H.required True ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.title ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "`titleHidden` removes the title from the window" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.titleHidden ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.window ]
                    |> Q.children [ S.tag "h2" ]
                    |> Q.count (E.equal 0)
        , T.test "`titleHidden` removes labelledby attribute" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.titleHidden ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.hasNot
                        [ S.attribute <|
                            Html.attribute "aria-labellby" <|
                                Dialog.id "foo" Dialog.title
                        ]
        , T.test "`titleHidden` sets the label of the widget" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    [ Dialog.titleHidden ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "bar" ]
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
        , T.test "Adds custom node" <|
            \() ->
                Widgets.dialog { id = "foo", title = "bar" }
                    []
                    [ ( Dialog.window, H.p [] [ H.text "qux" ] ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| Dialog.id "foo" Dialog.window ]
                    |> Q.find [ S.tag "p" ]
                    |> Q.contains [ Html.text "qux" ]
        ]
