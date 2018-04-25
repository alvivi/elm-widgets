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
import Widgets.Form.Elements as Elements


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
                    [ ( Elements.description, H.span [] [ H.text "one" ] )
                    , ( Elements.description, H.span [] [ H.text "two" ] )
                    , ( Elements.input, H.span [] [ H.text "one" ] )
                    , ( Elements.input, H.span [] [ H.text "two" ] )
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
        , T.test "Applies `whenHasIcon` attributes when control has an icon" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.whenHasIcon [ Form.placeholder "foobar" ] ]
                    [ ( Elements.icon, H.text "icon" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
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
                    [ ( Elements.description, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.contains [ Html.text "foobar" ]
        ]


icon : Test
icon =
    T.describe "Icon Element"
        [ T.test "Has custom icon html" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    []
                    [ ( Elements.icon, H.text "foobar" )
                    ]
                    |> Helpers.fromStyledHtml
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "Icon view is always after input (regression)" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    []
                    [ ( Elements.icon, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.children []
                    |> Q.index -1
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
                    [ ( Elements.description, H.text "desc" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Has custom input html" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    []
                    [ ( Elements.input, H.text "foobar" ) ]
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


semanticInput : Test
semanticInput =
    T.describe "Semantic Input Controls"
        [ T.test "currentPassword input type is password" <|
            \() ->
                Form.currentPassword { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "password" ]
        , T.test "currentPassword has attribute autocomplete set to current-password" <|
            \() ->
                Form.currentPassword { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "current-password" ]
        , T.test "email input type is email" <|
            \() ->
                Form.email { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "email" ]
        , T.test "email has attribute autocomplete set to email" <|
            \() ->
                Form.email { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "email" ]
        , T.test "firstName input type is text" <|
            \() ->
                Form.firstName { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "text" ]
        , T.test "firstName has attribute autocomplete set to given-name" <|
            \() ->
                Form.firstName { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "given-name" ]
        , T.test "lastName input type is text" <|
            \() ->
                Form.lastName { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "text" ]
        , T.test "lastName has attribute autocomplete set to given-name" <|
            \() ->
                Form.lastName { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "family-name" ]
        , T.test "newPassword input type is password" <|
            \() ->
                Form.newPassword { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "password" ]
        , T.test "newPassword has attribute autocomplete set to new-password" <|
            \() ->
                Form.newPassword { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "new-password" ]
        , T.test "nickname input type is text" <|
            \() ->
                Form.nickname { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "text" ]
        , T.test "nickname has attribute autocomplete set to given-name" <|
            \() ->
                Form.nickname { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "nickname" ]
        , T.test "organization input type is text" <|
            \() ->
                Form.organization { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "text" ]
        , T.test "organization has attribute autocomplete set to given-name" <|
            \() ->
                Form.organization { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "autocomplete" "organization" ]
        , T.test "text input type is text" <|
            \() ->
                Form.text { id = "id", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.type_ "text" ]
        ]
