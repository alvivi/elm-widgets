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
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form
import Widgets.ListBox as Widgets
import Widgets.ListBox.Attributes as ListBox
import Widgets.ListBox.Elements as ListBox
import Widgets.ListBox.Internal.Elements as ListBox


listBox : Test
listBox =
    T.describe "ListBox Widget"
        [ T.test "Has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.id "foobar" ]
        , T.test "`description` adds custom attributes to the description" <|
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
        , T.test "`descriptionLabel` sets aria-labeledby on button and list" <|
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
        , T.test "`descriptionLabel` attribute shows the description" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" }
                    [ ListBox.descriptionLabel
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| ListBox.id "id" ListBox.Description ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Description element adds children nodes" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ( ListBox.description, H.text "custom foobar" )
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id <| ListBox.id "id" ListBox.Description ]
                    |> Q.contains [ Html.text "custom foobar" ]
        , T.test "Applies `whenExpanded` attributes when exapended" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.whenExpanded [ ListBox.placeholder "foobar" ]
                    , ListBox.expanded
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        ]


button : Test
button =
    T.describe "Button element"
        [ T.test "Has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.Button ]
        , T.test "Sets aria haspopup attribute" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-haspopup" "listbox" ]
        , T.test "Sets aria label attribute" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Has description as children text if no button content is provided" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Has placeholder as children text if no option is selected" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.placeholder "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Has first text option if there is no option selected" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, id = "1", text = "foobar" }
                    , ListBox.textOption { selected = False, id = "2", text = "qux" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Has selected option text as children text node" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, id = "1", text = "qux" }
                    , ListBox.textOption { selected = True, id = "2", text = "foobar" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Sets aria-expanded if the ListBox is expanded" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.expanded ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-expanded" "true" ]
        , T.test "Adds children nodes" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" } [] [ ListBox.textButton "foobar" ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Adds custom attributes to the button" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.buttonAttributes
                        [ Form.html Form.control [ H.required True ]
                        ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "button" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        ]


list : Test
list =
    T.describe "List element"
        [ T.test "Has the provided id" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.id <| ListBox.id "foobar" ListBox.List ]
        , T.test "Sets aria label attribute" <|
            \() ->
                Widgets.listBox { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Sets aria role to listbox" <|
            \() ->
                Widgets.listBox { id = "foobar", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "listbox" ]
        , T.test "Sets aria active descendant to the selected option" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, id = "foo", text = "foo" }
                    , ListBox.textOption { selected = True, id = "bar", text = "bar" }
                    , ListBox.textOption { selected = False, id = "qux", text = "qux" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "ul" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-activedescendant" "bar" ]
        , T.test "Adds options children nodes in order" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, text = "first", id = "1" }
                    , ListBox.textOption { selected = False, text = "second", id = "2" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.findAll [ S.tag "li" ]
                    |> Expect.all
                        [ Q.first >> Q.contains [ Html.text "first" ]
                        , Q.index 1 >> Q.contains [ Html.text "second" ]
                        ]
        , T.test "Option nodes keep provided id" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    []
                    [ ListBox.textOption { selected = False, text = "text", id = "foobar" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "li" ]
                    |> Q.has [ S.attribute <| Html.id "foobar" ]
        , T.test "Options set custom html attributes" <|
            \() ->
                Widgets.listBox { id = "id", description = "desc" }
                    [ ListBox.html ListBox.anyOption [ H.required True ] ]
                    [ ListBox.textOption { selected = False, text = "text", id = "foobar" }
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "li" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        ]
