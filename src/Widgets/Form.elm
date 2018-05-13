module Widgets.Form
    exposing
        ( button
        , currentPassword
        , email
        , firstName
        , input
        , lastName
        , link
        , newPassword
        , nickname
        , organization
        , select
        , submit
        , text
        , textarea
        )

{-| Form controls following ARIA recommendations.


# Controls

@docs button, email, input, link, text, select, textarea


## Semantic Wrappers

@docs currentPassword, firstName, lastName, newPassword, nickname, organization, submit

-}

import Array exposing (Array)
import Css as C
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Attributes.Aria.Invalid as Aria
import Html.Styled.Attributes.Aria.Role as Aria
import Html.Styled.Events as H
import KeywordList as K exposing (KeywordList)
import Widgets.Form.Attributes as Form exposing (Attribute)
import Widgets.Form.Elements as Elements exposing (Element)
import Widgets.Form.Internal.Context as Context exposing (Context)
import Widgets.Form.Internal.Elements as Element
import Widgets.Helpers.Array as Array
import Widgets.Helpers.Css as C


-- Buttons --


{-| A straightforward button. Only `css`, `disabled`, `html` and events
attributes are supported by buttons.
-}
button : List (Attribute msg) -> List (Html msg) -> Html msg
button attrs =
    Context.empty
        |> Context.insertAttributes attrs
        |> buttonView


{-| A link is a button, but a `<a>` node is used instead of a `<button>`.
-}
link : List (Attribute msg) -> List (Html msg) -> Html msg
link attrs =
    Context.empty
        |> Context.insertAttributes attrs
        |> Context.setType "link"
        |> buttonView


{-| A semantic button for submitting forms. Same as button but with `type`
attribute set to `"submit"`.
-}
submit : List (Attribute msg) -> List (Html msg) -> Html msg
submit attrs =
    Context.empty
        |> Context.insertAttributes attrs
        |> Context.setType "submit"
        |> buttonView


buttonView : Context msg -> List (Html msg) -> Html msg
buttonView ctx content =
    let
        element =
            if ctx.type_ == "link" then
                H.a
            else
                H.button
    in
        element
            (K.fromMany
                [ K.ifTrue ctx.disabled <| H.disabled True
                , K.ifTrue (ctx.type_ == "submit") (H.type_ "submit")
                , K.maybeMap H.onBlur ctx.onBlur
                , K.maybeMap H.onClick ctx.onClick
                , K.maybeMap H.onFocus ctx.onFocus
                , K.many (Array.toList ctx.controlAttrs)
                , K.one <|
                    H.css <|
                        K.fromMany
                            [ K.one <| C.display C.inlineBlock
                            , K.many <| Array.toList ctx.controlCss
                            , K.ifTrue ctx.disabled <| C.cursor C.notAllowed
                            , K.ifTrue (ctx.type_ == "link" && not ctx.disabled) (C.cursor C.default)
                            ]
                ]
            )
            content



-- Inputs --


{-| A semantic password input with a current password value. Useful for log in
forms. Equal to a password input control with autocomplete attribute set to
`"current-password"`.
-}
currentPassword :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
currentPassword { id, description } attrs elems =
    input { id = id, description = description, type_ = "password" }
        (Form.autocomplete "current-password" :: attrs)
        elems


{-| A semantic email input. Equal to an email input control with autocomplete
attribute set to `"email"`.
-}
email :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
email { id, description } attrs elems =
    input { id = id, description = description, type_ = "email" }
        (Form.autocomplete "email" :: attrs)
        elems


{-| A semantic text input with a first name value. Equal to a text input control
with autocomplete attribute set to `"given-name"`.
-}
firstName :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
firstName { id, description } attrs elems =
    input { id = id, description = description, type_ = "text" }
        (Form.autocomplete "given-name" :: attrs)
        elems


{-| A semantic text input with a last name value. Equal to a text input control
with autocomplete attribute set to `"family-name"`.
-}
lastName :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
lastName { id, description } attrs elems =
    input { id = id, description = description, type_ = "text" }
        (Form.autocomplete "family-name" :: attrs)
        elems


{-| A semantic password input with a new password value. Useful for sign up
forms. Equal to a password input control with autocomplete attribute set to
`"new-password"`.
-}
newPassword :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
newPassword { id, description } attrs elems =
    input { id = id, description = description, type_ = "password" }
        (Form.autocomplete "new-password" :: attrs)
        elems


{-| A semantic text input with a nickname value. Equal to a text input control
with autocomplete attribute set to `"nickname"`.
-}
nickname :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
nickname { id, description } attrs elems =
    input { id = id, description = description, type_ = "text" }
        (Form.autocomplete "nickname" :: attrs)
        elems


{-| A semantic text input with an organization name value. Equal to a text input
control with autocomplete attribute set to `"organization"`.
-}
organization :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
organization { id, description } attrs elems =
    input { id = id, description = description, type_ = "text" }
        (Form.autocomplete "organization" :: attrs)
        elems


{-| A text input. Equal to a input control with a type attribute set to text.
-}
text :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
text { id, description } =
    input { id = id, description = description, type_ = "text" }


{-| A generic input control. An `id` and a `description` is always required.
`type` is the type of input, it could be `text`, `email`, `submit` or any
[other](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input).
Usually, is better to use the other semantic controls provided by this module.
-}
input :
    { id : String, description : String, type_ : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
input { id, description, type_ } attrs elements =
    let
        ctx =
            Context.empty
                |> Context.setDescription description
                |> Context.setId id
                |> Context.setType type_
                |> Context.insertElements elements
                |> Context.insertAttributes attrs
    in
        labelView ctx <| K.group [ inputView ctx, errorView ctx, iconView ctx ]


{-| A select control. An `id` and a `description` is always required. You can
add options using the `control` element.

    Form.select { id = "select", description = "A description" } []
        [ ( Elements.control, H.option [] [ H.text "one" ] )
        , ( Elements.control, H.option [] [ H.text "two" ] )
        , ( Elements.control, H.option [] [ H.text "three" ] )
        ]

-}
select :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
select { id, description } attrs elements =
    let
        ctx =
            Context.empty
                |> Context.setDescription description
                |> Context.setId id
                |> Context.setType "select"
                |> Context.insertElements elements
                |> Context.insertAttributes attrs
    in
        labelView ctx <| K.group [ selectView ctx, errorView ctx, iconView ctx ]


{-| A textarea control. An `id` and a `description` is always required.
-}
textarea :
    { id : String, description : String }
    -> List (Attribute msg)
    -> List ( Element, Html msg )
    -> Html msg
textarea { id, description } attrs elements =
    let
        ctx =
            Context.empty
                |> Context.setDescription description
                |> Context.setId id
                |> Context.setType "textarea"
                |> Context.insertElements elements
                |> Context.insertAttributes attrs
    in
        labelView ctx <| K.group [ textareaView ctx, errorView ctx, iconView ctx ]



-- Common Elements --


labelView : Context msg -> KeywordList (Html msg) -> Html msg
labelView ctx content =
    H.label
        [ H.id <| elementId ctx.id Element.Label
        , H.css <|
            K.fromMany
                [ K.one <| C.position C.relative
                , K.one <| C.display C.inlineBlock
                , K.many <| Array.toList ctx.labelCss
                ]
        ]
        (K.fromMany
            [ K.many <| Array.toList <| labelContentView ctx
            , content
            ]
        )


labelContentView : Context msg -> Array (Html msg)
labelContentView ctx =
    if Array.isEmpty ctx.descriptionHtml then
        if ctx.descriptionLabel then
            Array.singleton <|
                H.span
                    [ H.css <|
                        K.fromMany
                            [ K.one <| C.display C.block
                            , K.many <| Array.toList ctx.descriptionCss
                            ]
                    ]
                    [ H.text ctx.description ]
        else
            Array.empty
    else
        ctx.descriptionHtml


errorView : Context msg -> KeywordList (Html msg)
errorView ctx =
    K.one <|
        H.em
            [ Aria.role Aria.Alert
            , H.id <| elementId ctx.id Element.Error
            , H.css <| Array.toList ctx.errorCss
            ]
            (if Array.isEmpty ctx.errorHtml then
                case ctx.error of
                    Just error ->
                        [ H.text error ]

                    Nothing ->
                        [ H.span
                            [ Aria.hidden True
                            , H.css [ C.visibility C.hidden ]
                            ]
                            [ H.text ".keep" ]
                        ]
             else
                Array.toList ctx.errorHtml
            )


iconView : Context msg -> KeywordList (Html msg)
iconView { iconCss, iconHtml, type_ } =
    if Array.isEmpty iconHtml then
        K.zero
    else
        let
            hasStyle =
                Array.isEmpty iconCss

            isSelect =
                type_ == "select"
        in
            K.one <|
                H.div
                    [ Aria.hidden True
                    , H.css <|
                        K.fromMany
                            [ K.ifTrue (hasStyle && isSelect) <| C.paddingRight iconPaddingHorizontal
                            , K.ifTrue (hasStyle && not isSelect) <| C.paddingLeft iconPaddingHorizontal
                            , K.ifTrue hasStyle <| C.height iconSide
                            , K.ifTrue hasStyle <| C.paddingTop iconPaddingVertical
                            , K.ifTrue hasStyle <| C.width iconSide
                            , K.ifTrue isSelect <| C.right C.zero
                            , K.many
                                [ C.pointerEvents C.none
                                , C.position C.absolute
                                , C.top C.zero
                                ]
                            , K.many <| Array.toList iconCss
                            ]
                    ]
                    (Array.toList iconHtml)



-- Inputs Control --


inputView : Context msg -> KeywordList (Html msg)
inputView ctx =
    K.one <|
        H.input
            (K.fromMany
                [ K.one <| H.id <| elementId ctx.id Element.Control
                , K.ifTrue (Array.isEmpty <| labelContentView ctx) (Aria.label ctx.description)
                , K.ifTrue (Context.hasError ctx) <| Aria.describedBy [ elementId ctx.id Element.Error ]
                , K.ifTrue (Context.hasError ctx) <| Aria.invalid Aria.Invalid
                , K.ifTrue ctx.disabled <| H.disabled True
                , K.ifTrue ctx.required <| H.required True
                , K.maybeMap (H.attribute "autocomplete") ctx.autocomplete
                , K.maybeMap H.onBlur ctx.onBlur
                , K.maybeMap H.onClick ctx.onClick
                , K.maybeMap H.onFocus ctx.onFocus
                , K.maybeMap H.onInput ctx.onInput
                , K.maybeMap H.placeholder ctx.placeholder
                , K.maybeMap H.value ctx.value
                , K.one <| H.type_ ctx.type_
                , K.one <|
                    H.css <|
                        K.fromMany
                            [ K.many <| Array.toList ctx.controlCss
                            , K.ifTrue ctx.disabled <| C.cursor C.notAllowed
                            , K.one <| C.width <| C.pct 100
                            , K.maybeMap C.paddingLeft <| iconPadding ctx
                            ]
                , K.many <| Array.toList ctx.controlAttrs
                ]
            )
            (Array.toList ctx.controlHtml)



-- Select Control --


selectView : Context msg -> KeywordList (Html msg)
selectView ctx =
    let
        isAppearanceAffected =
            (not <| Array.isEmpty ctx.controlCss) || (not <| Array.isEmpty ctx.iconHtml)
    in
        K.one <|
            H.select
                (K.fromMany
                    [ K.one <| H.id <| elementId ctx.id Element.Control
                    , K.ifTrue (Array.isEmpty <| labelContentView ctx) (Aria.label ctx.description)
                    , K.ifTrue (Context.hasError ctx) <| Aria.describedBy [ elementId ctx.id Element.Error ]
                    , K.ifTrue (Context.hasError ctx) <| Aria.invalid Aria.Invalid
                    , K.ifTrue ctx.disabled <| H.disabled True
                    , K.ifTrue ctx.required <| H.required True
                    , K.maybeMap H.onBlur ctx.onBlur
                    , K.maybeMap H.onClick ctx.onClick
                    , K.maybeMap H.onFocus ctx.onFocus
                    , K.maybeMap H.onInput ctx.onInput
                    , K.one <|
                        H.css <|
                            K.fromMany
                                [ K.many <| Array.toList ctx.controlCss
                                , K.ifTrue ctx.disabled <| C.cursor C.notAllowed
                                , K.ifTrue isAppearanceAffected (C.appearance "none")
                                , K.one <| C.minHeight iconSide
                                , K.one <| C.width <| C.pct 100
                                ]
                    , K.many <| Array.toList ctx.controlAttrs
                    ]
                )
                (K.fromMany
                    [ selectPlaceholderView ctx
                    , K.many <| Array.toList ctx.controlHtml
                    ]
                )


selectPlaceholderView : Context msg -> KeywordList (Html msg)
selectPlaceholderView ctx =
    case ctx.placeholder of
        Nothing ->
            K.zero

        Just title ->
            K.one <|
                H.option
                    [ H.disabled True
                    , H.selected True
                    ]
                    [ H.text title ]



-- Textarea Control --


textareaView : Context msg -> KeywordList (Html msg)
textareaView ctx =
    -- NOTE: Maybe refactor textareaView and inputView together?
    K.one <|
        H.textarea
            (K.fromMany
                [ K.one <| H.id <| elementId ctx.id Element.Control
                , K.ifTrue (Array.isEmpty <| labelContentView ctx) (Aria.label ctx.description)
                , K.ifTrue (Context.hasError ctx) <| Aria.describedBy [ elementId ctx.id Element.Error ]
                , K.ifTrue (Context.hasError ctx) <| Aria.invalid Aria.Invalid
                , K.ifTrue ctx.disabled <| H.disabled True
                , K.ifTrue ctx.required <| H.required True
                , K.maybeMap (H.attribute "autocomplete") ctx.autocomplete
                , K.maybeMap H.onBlur ctx.onBlur
                , K.maybeMap H.onClick ctx.onClick
                , K.maybeMap H.onFocus ctx.onFocus
                , K.maybeMap H.onInput ctx.onInput
                , K.maybeMap H.placeholder ctx.placeholder
                , K.maybeMap H.value ctx.value
                , K.one <|
                    H.css <|
                        K.fromMany
                            [ K.many <| Array.toList ctx.controlCss
                            , K.ifTrue ctx.disabled <| C.cursor C.notAllowed
                            , K.one <| C.width <| C.pct 100
                            , K.maybeMap C.paddingLeft <| iconPadding ctx
                            ]
                , K.many <| Array.toList ctx.controlAttrs
                ]
            )
            (Array.toList ctx.controlHtml)



-- Values --


iconSide : C.Px
iconSide =
    C.px 24


iconPaddingVertical : C.Px
iconPaddingVertical =
    C.px 3


iconPaddingHorizontal : C.Px
iconPaddingHorizontal =
    C.px 4


iconPadding : Context msg -> Maybe C.Px
iconPadding { iconCss, iconHtml } =
    if Array.isEmpty iconHtml || not (Array.isEmpty iconCss) then
        Nothing
    else
        Just <|
            C.px (iconSide.numericValue + iconPaddingHorizontal.numericValue)



-- Helpers --


elementId : String -> Element -> String
elementId base subElement =
    case subElement of
        Element.Control ->
            base

        Element.Description ->
            base ++ "__description"

        Element.Error ->
            base ++ "__error"

        Element.Icon ->
            base ++ "__icon"

        Element.Label ->
            base ++ "__label"
