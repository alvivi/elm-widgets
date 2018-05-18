module Widgets.ListBox.Internal.Context
    exposing
        ( Context
        , empty
        , insertAttributes
        , insertElements
        , setId
        )

import Array exposing (Array)
import Css exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.ListBox.Internal.Attributes as Attributes exposing (Attribute)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element)


type alias Context msg =
    { buttonAttrs : Array (H.Attribute msg)
    , buttonCss : Array Style
    , buttonHtml : Array (Html msg)
    , id : String
    , listAttrs : Array (H.Attribute msg)
    , listCss : Array Style
    , optionsHtml : Array (Html msg)
    , wrapperAttrs : Array (H.Attribute msg)
    , wrapperCss : Array Style
    }


empty : Context msg
empty =
    { buttonAttrs = Array.empty
    , buttonCss = Array.empty
    , buttonHtml = Array.empty
    , id = ""
    , listAttrs = Array.empty
    , listCss = Array.empty
    , optionsHtml = Array.empty
    , wrapperAttrs = Array.empty
    , wrapperCss = Array.empty
    }


setId : String -> Context msg -> Context msg
setId id context =
    { context | id = id }


insertAttributes : List (Attribute msg) -> Context msg -> Context msg
insertAttributes attrs ctx =
    --|> (\ctx_ -> List.foldl setAttributeModifiers ctx_ attrs)
    attrs
        |> List.foldl setAttribute ctx


insertElements : List ( Element, Html msg ) -> Context msg -> Context msg
insertElements elements ctx =
    List.foldl setElement ctx elements


setAttribute : Attribute msg -> Context msg -> Context msg
setAttribute attr ctx =
    case attr of
        Attributes.Css element css ->
            setCss element css ctx

        Attributes.Html element css ->
            setHtmlAttributes element css ctx


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Button ->
            { ctx | buttonCss = Array.push css ctx.buttonCss }

        Elements.List ->
            { ctx | listCss = Array.push css ctx.listCss }

        Elements.Option ->
            let
                _ =
                    Debug.log "Warning" "Custom options css is not supported"
            in
                ctx

        Elements.Wrapper ->
            { ctx | wrapperCss = Array.push css ctx.wrapperCss }


setElement : ( Element, Html msg ) -> Context msg -> Context msg
setElement ( element, html ) ctx =
    case element of
        Elements.Button ->
            { ctx | buttonHtml = Array.push html ctx.buttonHtml }

        Elements.List ->
            let
                _ =
                    Debug.log "Warning" "Custom list element is not supported"
            in
                ctx

        Elements.Option ->
            { ctx | optionsHtml = Array.push html ctx.optionsHtml }

        Elements.Wrapper ->
            let
                _ =
                    Debug.log "Warning" "Custom list element is not supported"
            in
                ctx


setHtmlAttributes : Element -> List (H.Attribute msg) -> Context msg -> Context msg
setHtmlAttributes element attrs ctx =
    case element of
        Elements.Button ->
            { ctx | buttonAttrs = Array.append (Array.fromList attrs) ctx.buttonAttrs }

        Elements.List ->
            { ctx | listAttrs = Array.append (Array.fromList attrs) ctx.listAttrs }

        Elements.Option ->
            let
                _ =
                    Debug.log "Warning" "Custom HTML attributes are not supported"
            in
                ctx

        Elements.Wrapper ->
            { ctx | wrapperAttrs = Array.append (Array.fromList attrs) ctx.wrapperAttrs }
