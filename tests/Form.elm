module Form exposing (..)

import Expect
import Helpers
import Html
import Html.Attributes as Html
import Html.Styled as H
import Html.Styled.Attributes as H
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
    | OnClick
    | OnFocus
    | OnInput String



-- Controls --


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
                    , ( Elements.control, H.span [] [ H.text "one" ] )
                    , ( Elements.control, H.span [] [ H.text "two" ] )
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
        , T.test "Applies `whenHasDescriptionLabel` attributes when descriptionLabel attribute is present" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "foo" }
                    [ Form.whenHasDescriptionLabel [ Form.placeholder "foobar" ]
                    , Form.descriptionLabel
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "Applies `whenHasDescriptionLabel` attributes when a custom label is provided" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "foo" }
                    [ Form.whenHasDescriptionLabel [ Form.placeholder "foobar" ] ]
                    [ ( Elements.description, H.text "to the moon" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "Applies `whenHasIcon` attributes when control has an icon" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.whenHasIcon [ Form.placeholder "foobar" ] ]
                    [ ( Elements.icon, H.text "icon" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "Applies `whenHasType` attributes when control has the chosen type" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "foo" }
                    [ Form.whenHasType "foo" [ Form.placeholder "foobar" ] ]
                    [ ( Elements.icon, H.text "icon" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
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
                    [ ( Elements.control, H.text "foobar" ) ]
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
        , T.test "onClick attribute sets a click event handler" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.onClick OnClick ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> E.simulate E.click
                    |> E.expect OnClick
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
        , T.test "custom html attributes are set" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.html Elements.control [ H.attribute "foo" "bar" ] ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "foo" "bar" ]
        , T.test "attributes modifiers overrides previous values" <|
            \() ->
                Form.input { id = "id", description = "desc", type_ = "text" }
                    [ Form.focused
                    , Form.whenFocused
                        [ Form.html Elements.control [ H.attribute "foo" "two" ]
                        ]
                    , Form.html Elements.control [ H.attribute "foo" "one" ]
                    ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.has [ S.attribute <| Html.attribute "foo" "two" ]
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


button : Test
button =
    T.describe "Buttons"
        [ T.test "A button is a button" <|
            \() ->
                Form.button [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.tag "button" ]
        , T.test "disabled sets html disabled attribute" <|
            \() ->
                Form.button [ Form.disabled ] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.disabled True ]
        , T.test "onBlur attribute sets a blur event handler" <|
            \() ->
                Form.button [ Form.onBlur OnBlur ] []
                    |> Helpers.fromStyledHtml
                    |> E.simulate E.blur
                    |> E.expect OnBlur
        , T.test "onClick attribute sets a blur event handler" <|
            \() ->
                Form.button [ Form.onClick OnClick ] []
                    |> Helpers.fromStyledHtml
                    |> E.simulate E.click
                    |> E.expect OnClick
        , T.test "onFocus attribute sets a focus event handler" <|
            \() ->
                Form.button [ Form.onFocus OnFocus ] []
                    |> Helpers.fromStyledHtml
                    |> E.simulate E.focus
                    |> E.expect OnFocus
        , T.test "custom html attributes are set" <|
            \() ->
                Form.button [ Form.html Elements.control [ H.attribute "foo" "bar" ] ] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.attribute "foo" "bar" ]
        , T.test "submit button has its type set to submit" <|
            \() ->
                Form.submit [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.attribute <| Html.type_ "submit" ]
        , T.test "link button is an <a>" <|
            \() ->
                Form.link [] []
                    |> Helpers.fromStyledHtml
                    |> Q.has [ S.tag "a" ]
        ]


select : Test
select =
    T.describe "Select Control"
        [ T.test "Has the provided id" <|
            \() ->
                Form.select { id = "foo", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.id "foo" ]
        , T.test "Contains the description in ARIA label attribute" <|
            \() ->
                Form.select { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "descriptionLabel attribute disables ARIA label attribute" <|
            \() ->
                Form.select { id = "id", description = "foobar" }
                    [ Form.descriptionLabel ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "input" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Custom description html disables ARIA label attribute" <|
            \() ->
                Form.select { id = "id", description = "foobar" }
                    []
                    [ ( Elements.description, H.text "desc" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Has custom control html" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    []
                    [ ( Elements.control, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "onBlur attribute sets a blur event handler" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.onBlur OnBlur ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> E.simulate E.blur
                    |> E.expect OnBlur
        , T.test "onClick attribute sets a click event handler" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.onClick OnClick ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> E.simulate E.click
                    |> E.expect OnClick
        , T.test "onFocus attribute sets a focus event handler" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.onFocus OnFocus ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> E.simulate E.focus
                    |> E.expect OnFocus
        , T.test "onInput attribute sets an input event handler" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.onInput OnInput ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> E.simulate (E.input "foobar")
                    |> E.expect (OnInput "foobar")
        , T.test "disabled sets html disabled attribute" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.disabled ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.attribute <| Html.disabled True ]
        , T.test "required attribute sets html required attribute" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.required ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "custom html attributes are set" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.html Elements.control [ H.attribute "foo" "bar" ] ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.attribute <| Html.attribute "foo" "bar" ]
        , T.test "Applies `whenHasType \"select\" attributes" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.whenHasType "select" [ Form.required ] ]
                    [ ( Elements.icon, H.text "icon" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "placeholder adds a selected and disabled option" <|
            \() ->
                Form.select { id = "id", description = "desc" }
                    [ Form.placeholder "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "select" ]
                    |> Q.children [ S.tag "option" ]
                    |> Q.first
                    |> Q.has
                        [ S.text "foobar"
                        , S.attribute <| Html.selected True
                        , S.attribute <| Html.disabled True
                        ]
        ]


textarea : Test
textarea =
    T.describe "Textarea Element"
        [ T.test "Has the provided id" <|
            \() ->
                Form.textarea { id = "foo", description = "desc" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.id "foo" ]
        , T.test "Contains the description in ARIA label attribute" <|
            \() ->
                Form.textarea { id = "id", description = "foobar" } [] []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "descriptionLabel attribute disables ARIA label attribute" <|
            \() ->
                Form.textarea { id = "id", description = "foobar" }
                    [ Form.descriptionLabel ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Custom description html disables ARIA label attribute" <|
            \() ->
                Form.textarea { id = "id", description = "foobar" }
                    []
                    [ ( Elements.description, H.text "desc" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.hasNot [ S.attribute <| Html.attribute "aria-label" "foobar" ]
        , T.test "Has custom textarea html" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    []
                    [ ( Elements.control, H.text "foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.contains [ Html.text "foobar" ]
        , T.test "onBlur attribute sets a blur event handler" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.onBlur OnBlur ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> E.simulate E.blur
                    |> E.expect OnBlur
        , T.test "onClick attribute sets a click event handler" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.onClick OnClick ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> E.simulate E.click
                    |> E.expect OnClick
        , T.test "onFocus attribute sets a focus event handler" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.onFocus OnFocus ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> E.simulate E.focus
                    |> E.expect OnFocus
        , T.test "onInput attribute sets an input event handler" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.onInput OnInput ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> E.simulate (E.input "foobar")
                    |> E.expect (OnInput "foobar")
        , T.test "disabled sets html disabled attribute" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.disabled ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.disabled True ]
        , T.test "placeholder attribute sets html placeholder attribute" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.placeholder "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.placeholder "foobar" ]
        , T.test "required attribute sets html required attribute" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.required ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        , T.test "value attribute sets html value attribute" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.value "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.value "foobar" ]
        , T.test "custom html attributes are set" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.html Elements.control [ H.attribute "foo" "bar" ] ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.attribute "foo" "bar" ]
        , T.test "Applies `whenHasType \"textarea\" attributes" <|
            \() ->
                Form.textarea { id = "id", description = "desc" }
                    [ Form.whenHasType "textarea" [ Form.required ] ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.tag "textarea" ]
                    |> Q.has [ S.attribute <| Html.required True ]
        ]



-- Elements --


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


error : Test
error =
    T.describe "Error Element"
        [ T.test "Alert element is present even when not requested" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    []
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id "id__error" ]
                    |> Q.has [ S.attribute <| Html.attribute "role" "alert" ]
        , T.test "Alert element has always inner text to keep spacing" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    []
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id "id__error" ]
                    |> Expect.all
                        [ Q.contains [ Html.text ".keep" ]
                        , Q.has [ S.attribute <| Html.attribute "aria-hidden" "true" ]
                        ]
        , T.test "Error attribute sets the inner text and makes the element visible" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    [ Form.error "foobar" ]
                    []
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id "id__error" ]
                    |> Expect.all
                        [ Q.contains [ Html.text "foobar" ]
                        , Q.hasNot [ S.attribute <| Html.attribute "aria-hidden" "true" ]
                        ]
        , T.test "Custom error element overrides the default error" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    [ Form.error "foobar" ]
                    [ ( Elements.error, H.text "custom foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id "id__error" ]
                    |> Expect.all
                        [ Q.contains [ Html.text "custom foobar" ]
                        , Q.hasNot [ S.attribute <| Html.attribute "aria-hidden" "true" ]
                        ]
        , T.test "Custom error element, alone, also enables visibility (regression)" <|
            \() ->
                Form.text { id = "id", description = "desc" }
                    []
                    [ ( Elements.error, H.text "custom foobar" ) ]
                    |> Helpers.fromStyledHtml
                    |> Q.find [ S.id "id__error" ]
                    |> Expect.all
                        [ Q.hasNot [ S.attribute <| Html.attribute "aria-hidden" "true" ]
                        ]
        ]
