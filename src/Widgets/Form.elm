module Widgets.Form exposing (input)

{-| Form controls following ARIA recommendations.


# Controls

@docs input

-}

import Array exposing (Array)
import Css as C
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Events as H
import KeywordList as K
import Widgets.Form.Attributes exposing (Attribute)
import Widgets.Form.Elements as Element exposing (Element)
import Widgets.Form.Internal.Context as Context exposing (Context)
import Widgets.Helpers.Array as Array


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
input config attrs elements =
    let
        ctx =
            config
                |> Context.empty
                |> Context.insertAttributes attrs
                |> Context.insertElements elements
    in
        labelView ctx [ inputView ctx ]



-- Elements Rendering --


labelView : Context msg -> List (Html msg) -> Html msg
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
            , K.many content
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


inputView : Context msg -> Html msg
inputView ctx =
    H.input
        (K.fromMany
            [ K.one <| H.id <| elementId ctx.id Element.Input
            , K.ifTrue (Array.isEmpty <| labelContentView ctx) (Aria.label ctx.description)
            , K.ifTrue ctx.disabled <| H.disabled True
            , K.ifTrue ctx.required <| H.required True
            , K.maybeMap H.onBlur ctx.onBlur
            , K.maybeMap H.onFocus ctx.onFocus
            , K.maybeMap H.onInput ctx.onInput
            , K.maybeMap H.placeholder ctx.placeholder
            , K.maybeMap H.value ctx.value
            , K.one <| H.type_ ctx.type_
            , K.one <|
                H.css <|
                    K.fromMany
                        [ K.many <| Array.toList ctx.inputCss
                        ]
            ]
        )
        (Array.toList ctx.inputHtml)



-- Helpers --


elementId : String -> Element -> String
elementId base subElement =
    case subElement of
        Element.Description ->
            base ++ "__description"

        Element.Input ->
            base

        Element.Label ->
            base ++ "__label"
