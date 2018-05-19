module ListBox exposing (..)

import Expect
import Helpers
import Html
import Html.Attributes as Html
import Html.Styled as H
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
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.id "foobar" ]
        , T.test "Button element has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.Button ]
        , T.test "List element has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.List ]
        , T.test "Button sets aria haspopup attribute" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-haspopup" "dialog" ]
        , T.test "Button sets aria label attribute" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "List sets aria label attribute" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "List sets aria role to listbox" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "listbox" ]
        ]


attributes : Test
attributes =
    T.describe "ListBox Widget attributes"
        [ T.test "`html ListBox.button` adds custom attributes to the button" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.html ListBox.button
                        [ H.required True
                        ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "`html ListBox.description` adds custom attributes to the description" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" }
                    [ ListBox.descriptionLabel
                    , ListBox.html ListBox.description
                        [ H.required True
                        ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| ListBox.id "id" ListBox.Description ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "descriptionLabel attribute sets aria-labeledby on button and list" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" }
                    [ ListBox.descriptionLabel
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Expect.all
                        [ Q.find [ S.tag "button" ] >> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
                        , Q.find [ S.tag "button" ] >> Q.has [ S.attribute <| Html.attribute "aria-labelledby" <| ListBox.id "id" ListBox.Description ]
                        , Q.find [ S.tag "ul" ] >> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
                        , Q.find [ S.tag "ul" ] >> Q.has [ S.attribute <| Html.attribute "aria-labelledby" <| ListBox.id "id" ListBox.Description ]
                        ]
        , T.test "descriptionLabel attribute shows the description" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" }
                    [ ListBox.descriptionLabel
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| ListBox.id "id" ListBox.Description ]
                    |> Q.contains [ Html.text "foobar" ]
        ]


nodes : Test
nodes =
    T.describe "ListBox Widget custom nodes"
        [ T.test "Adds button children nodes" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" } [] [ ListBox.textButton "foobar" ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Adds description children nodes" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ( ListBox.description, H.text "custom foobar" )
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| ListBox.id "id" ListBox.Description ]
                    |> Q.contains [ Html.text "custom foobar" ]
        , T.test "Adds options children nodes in order" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
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
