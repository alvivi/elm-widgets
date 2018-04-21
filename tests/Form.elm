module Form exposing (..)

import Expect
import Helpers
import Html
import Html.Attributes as Html
import Html.Styled as H
import Test as T exposing (Test)
import Test.Html.Event as E
import Test.Html.Query as Q
import Test.Html.Selector as S
import Widgets.Form as Form
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form


{--

Test that cannot be done with the current elm-html-test feature set:
 * Custom css keeps original order
 * Label element has custom css styles
 * Input element has custom css styles

 --}


type Msg
    = OnBlur
    | OnFocus
    | OnInput String


form : Test
form =
    T.describe "Form Controls"
        [ T.test "The outmost element is a label" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.tag "label" ]
        , T.test "Custom html keeps original order" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    []
                    [ ( Form.Description, H.span [] [ H.text "one" ] )
                    , ( Form.Description, H.span [] [ H.text "two" ] )
                    , ( Form.Input, H.span [] [ H.text "one" ] )
                    , ( Form.Input, H.span [] [ H.text "two" ] )
                    ]
                    |> Helpers.fromStyledHtml
                    |> Expect.all
                        [ Q.children [ S.tag "span" ]
                            >> Expect.all
                                [ Q.first >> Q.contains [ Html.text "one" ]
                                , Q.index 1 >> Q.contains [ Html.text "two" ]
                                ]
                        , Q.findAll [ S.tag "input" ]
                            >> Q.keep (S.tag "span")
                            >> Expect.all
                                [ Q.first >> Q.contains [ Html.text "one" ]
                                , Q.index 1 >> Q.contains [ Html.text "two" ]
                                ]
                        ]
        , T.test "Applies `whenFocused` attributes when focused" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.whenFocused [ Form.placeholder "foobar" ]
                    , Form.focused
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "Applies batched `whenFocused` attributes when focused (regression)" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.batch
                        [ Form.whenFocused [ Form.placeholder "foobar" ]
                        ]
                    , Form.focused
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        ]


label : Test
label =
    T.describe "Label Element"
        [ T.test "Has its own id" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.id "id__label" ]
        , T.test "Has custom description html" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    []
                    [ ( Form.Description, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.contains [ Html.text "foobar" ]
        ]


input : Test
input =
    T.describe "Input Element"
        [ T.test "Has the provided id" <|
            \() ->
                Form.input { id = "foo", description = "desc", type_ = "text" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.id "foo" ]
        , T.test "Has the provided input type" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "foo" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "foo" ]
        , T.test "Contains the description in ARIA label attribute" <|
            \() ->
                Form.input { id = "id", description = "foobar", type_ = "text" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "descriptionLabel attribute disables ARIA label attribute" <|
            \() ->
                Form.input { id = "id", description = "foobar", type_ = "text" }
                    [ Form.descriptionLabel ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Custom description html disables ARIA label attribute" <|
            \() ->
                Form.input { id = "id", description = "foobar", type_ = "text" }
                    []
                    [ ( Form.Description, H.text "desc" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Has custom input html" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    []
                    [ ( Form.Input, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "onBlur attribute sets a blur event handler" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.onBlur OnBlur ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> E.simulate E.blur
                    |> E.expect OnBlur
        , T.test "onFocus attribute sets a focus event handler" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.onFocus OnFocus ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> E.simulate E.focus
                    |> E.expect OnFocus
        , T.test "onInput attribute sets an input event handler" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.onInput OnInput ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> E.simulate (E.input "foobar")
                    |> E.expect (OnInput "foobar")
        , T.test "disabled sets html disabled attribute" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "test" }
                    [ Form.disabled ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.disabled True ]
        , T.test "placeholder attribute sets html placeholder attribute" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.placeholder "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "required attribute sets html required attribute" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.required ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "value attribute sets html value attribute" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.value "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.value "foobar" ]
        ]
