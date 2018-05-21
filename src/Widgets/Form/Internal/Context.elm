module Widgets.Form.Internal.Context
    exposing
        ( Context
        , empty
        , hasError
        , insertAttributes
        , insertElements
        , setDescription
        , setId
        , setType
        )

import Array exposing (Array)
import Char exposing (KeyCode)
import Css exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Internal.Attributes as Attributes exposing (Attribute)
import Widgets.Form.Internal.Elements as Elements exposing (Element)


type alias Context msg =
    { autocomplete : Maybe String
    , controlAttrs : Array (H.Attribute msg)
    , controlCss : Array Style
    , controlHtml : Array (Html msg)
    , description : String
    , descriptionCss : Array Style
    , descriptionHtml : Array (Html msg)
    , descriptionLabel : Bool
    , disabled : Bool
    , error : Maybe String
    , errorCss : Array Style
    , errorHtml : Array (Html msg)
    , focused : Bool
    , iconCss : Array Style
    , iconHtml : Array (Html msg)
    , id : String
    , labelCss : Array Style
    , onBlur : Maybe msg
    , onClick : Maybe msg
    , onFocus : Maybe msg
    , onInput : Maybe (String -> msg)
    , onKeyUp : Maybe (KeyCode -> msg)
    , placeholder : Maybe String
    , required : Bool
    , type_ : String
    , value : Maybe String
    }


empty : Context msg
empty =
    { autocomplete = Nothing
    , controlAttrs = Array.empty
    , controlCss = Array.empty
    , controlHtml = Array.empty
    , description = ""
    , descriptionLabel = False
    , descriptionCss = Array.empty
    , descriptionHtml = Array.empty
    , disabled = False
    , error = Nothing
    , errorCss = Array.empty
    , errorHtml = Array.empty
    , focused = False
    , iconCss = Array.empty
    , iconHtml = Array.empty
    , id = ""
    , labelCss = Array.empty
    , onBlur = Nothing
    , onClick = Nothing
    , onFocus = Nothing
    , onInput = Nothing
    , onKeyUp = Nothing
    , placeholder = Nothing
    , required = False
    , type_ = ""
    , value = Nothing
    }


setDescription : String -> Context msg -> Context msg
setDescription description context =
    { context | description = description }


setId : String -> Context msg -> Context msg
setId id context =
    { context | id = id }


setType : String -> Context msg -> Context msg
setType type_ context =
    { context | type_ = type_ }


hasError : Context msg -> Bool
hasError { error, errorHtml } =
    error /= Nothing || not (Array.isEmpty errorHtml)


insertAttributes : List (Attribute msg) -> Context msg -> Context msg
insertAttributes attrs ctx =
    attrs
        |> List.foldl setAttribute ctx
        |> (\ctx_ -> List.foldl setAttributeModifiers ctx_ attrs)


insertElements : List ( Element, Html msg ) -> Context msg -> Context msg
insertElements elements ctx =
    List.foldl setElement ctx elements


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

        Attributes.Disabled ->
            { ctx | disabled = True }

        Attributes.Error error ->
            { ctx | error = Just error }

        Attributes.Focused ->
            { ctx | focused = True }

        Attributes.Html element css ->
            setHtmlAttributes element css ctx

        Attributes.OnBlur msg ->
            { ctx | onBlur = Just msg }

        Attributes.OnClick msg ->
            { ctx | onClick = Just msg }

        Attributes.OnFocus msg ->
            { ctx | onFocus = Just msg }

        Attributes.OnInput handler ->
            { ctx | onInput = Just handler }

        Attributes.OnKeyUp handler ->
            { ctx | onKeyUp = Just handler }

        Attributes.Placeholder placeholder ->
            { ctx | placeholder = Just placeholder }

        Attributes.Required ->
            { ctx | required = True }

        Attributes.Value value ->
            { ctx | value = Just value }

        Attributes.WhenErred _ ->
            ctx

        Attributes.WhenFocused _ ->
            ctx

        Attributes.WhenHasDescriptionLabel _ ->
            ctx

        Attributes.WhenHasIcon _ ->
            ctx

        Attributes.WhenHasType _ _ ->
            ctx


setAttributeModifiers : Attribute msg -> Context msg -> Context msg
setAttributeModifiers attr ctx =
    case attr of
        Attributes.Batch moreAttrs ->
            List.foldl setAttributeModifiers ctx moreAttrs

        Attributes.WhenErred erredAttrs ->
            if hasError ctx then
                insertAttributes erredAttrs ctx
            else
                ctx

        Attributes.WhenFocused focusedAttrs ->
            if ctx.focused then
                insertAttributes focusedAttrs ctx
            else
                ctx

        Attributes.WhenHasDescriptionLabel descAttrs ->
            if Array.isEmpty ctx.descriptionHtml && not ctx.descriptionLabel then
                ctx
            else
                insertAttributes descAttrs ctx

        Attributes.WhenHasIcon iconAttrs ->
            if Array.isEmpty ctx.iconHtml then
                ctx
            else
                insertAttributes iconAttrs ctx

        Attributes.WhenHasType type_ typeAttrs ->
            if ctx.type_ == type_ then
                insertAttributes typeAttrs ctx
            else
                ctx

        _ ->
            ctx


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Control ->
            { ctx | controlCss = Array.push css ctx.controlCss }

        Elements.Description ->
            { ctx | descriptionCss = Array.push css ctx.descriptionCss }

        Elements.Error ->
            { ctx | errorCss = Array.push css ctx.errorCss }

        Elements.Icon ->
            { ctx | iconCss = Array.push css ctx.iconCss }

        Elements.Label ->
            { ctx | labelCss = Array.push css ctx.labelCss }


setElement : ( Element, Html msg ) -> Context msg -> Context msg
setElement ( element, html ) ctx =
    case element of
        Elements.Control ->
            { ctx | controlHtml = Array.push html ctx.controlHtml }

        Elements.Description ->
            { ctx | descriptionHtml = Array.push html ctx.descriptionHtml }

        Elements.Error ->
            { ctx | errorHtml = Array.push html ctx.errorHtml }

        Elements.Icon ->
            { ctx | iconHtml = Array.push html ctx.iconHtml }

        Elements.Label ->
            let
                _ =
                    Debug.log "Warning" "Custom label element is not supported"
            in
                ctx


setHtmlAttributes : Element -> List (H.Attribute msg) -> Context msg -> Context msg
setHtmlAttributes element attrs ctx =
    case element of
        Elements.Control ->
            { ctx | controlAttrs = Array.append (Array.fromList attrs) ctx.controlAttrs }

        _ ->
            let
                _ =
                    Debug.log "Warning" "Custom html attributes are only supported in control element"
            in
                ctx
