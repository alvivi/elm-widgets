module Widgets.Form.Internal.Context
    exposing
        ( Context
        , empty
        , insertAttributes
        , insertElements
        )

import Array exposing (Array)
import Css exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Elements as Elements exposing (Element)
import Widgets.Form.Internal.Attributes as Attributes exposing (Attribute)


type alias Context msg =
    { autocomplete : Maybe String
    , description : String
    , descriptionLabel : Bool
    , focused : Bool
    , id : String
    , inputCss : Array Style
    , inputHtml : Array (Html msg)
    , labelCss : Array Style
    , labelHtml : Array (Html msg)
    , onBlur : Maybe msg
    , onFocus : Maybe msg
    , onInput : Maybe (String -> msg)
    , placeholder : Maybe String
    , required : Bool
    , type_ : String
    , value : Maybe String
    }


insertAttributes : List (Attribute msg) -> Context msg -> Context msg
insertAttributes attrs ctx =
    attrs
        |> List.foldl setAttribute ctx
        |> (\ctx_ -> List.foldl setAttributeModifiers ctx_ attrs)


insertElements : List ( Element, Html msg ) -> Context msg -> Context msg
insertElements elements ctx =
    List.foldl setElement ctx elements


empty : { description : String, id : String, type_ : String } -> Context msg
empty { description, id, type_ } =
    { autocomplete = Nothing
    , description = description
    , descriptionLabel = False
    , focused = False
    , id = id
    , inputCss = Array.empty
    , inputHtml = Array.empty
    , labelCss = Array.empty
    , labelHtml = Array.empty
    , onBlur = Nothing
    , onFocus = Nothing
    , onInput = Nothing
    , placeholder = Nothing
    , required = False
    , type_ = type_
    , value = Nothing
    }


setAttribute : Attribute msg -> Context msg -> Context msg
setAttribute attr ctx =
    case attr of
        Attributes.Autocomplete autocomplete ->
            { ctx | autocomplete = Just autocomplete }

        Attributes.Batch moreAttrs ->
            List.foldl setAttribute ctx moreAttrs

        Attributes.Css element css ->
            setCss element css ctx

        Attributes.DescriptionLabel ->
            { ctx | descriptionLabel = True }

        Attributes.Focused ->
            { ctx | focused = True }

        Attributes.OnBlur msg ->
            { ctx | onBlur = Just msg }

        Attributes.OnFocus msg ->
            { ctx | onFocus = Just msg }

        Attributes.OnInput handler ->
            { ctx | onInput = Just handler }

        Attributes.Placeholder placeholder ->
            { ctx | placeholder = Just placeholder }

        Attributes.Required ->
            { ctx | required = True }

        Attributes.Value value ->
            { ctx | value = Just value }

        Attributes.WhenFocused _ ->
            ctx


setAttributeModifiers : Attribute msg -> Context msg -> Context msg
setAttributeModifiers attr ctx =
    case attr of
        Attributes.WhenFocused focusedAttrs ->
            if ctx.focused then
                insertAttributes focusedAttrs ctx
            else
                ctx

        _ ->
            ctx


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Input ->
            { ctx | inputCss = Array.push css ctx.inputCss }

        Elements.Label ->
            { ctx | labelCss = Array.push css ctx.labelCss }


setElement : ( Element, Html msg ) -> Context msg -> Context msg
setElement ( element, html ) ctx =
    case element of
        Elements.Input ->
            { ctx | inputHtml = Array.push html ctx.inputHtml }

        Elements.Label ->
            { ctx | labelHtml = Array.push html ctx.labelHtml }
