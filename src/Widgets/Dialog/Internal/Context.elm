module Widgets.Dialog.Internal.Context
    exposing
        ( Context
        , empty
        , insertAttributes
        , insertElements
        , setId
        , setTitle
        )

import Array exposing (Array)
import Css as C exposing (Style)
import Html.Styled as H exposing (Html)
import Html.Styled exposing (Html)
import Widgets.Dialog.Internal.Attributes as Attributes exposing (Attribute)
import Widgets.Dialog.Internal.Elements as Elements exposing (Element)


type alias Context msg =
    { backdropAttrs : Array (H.Attribute msg)
    , backdropCss : Array Style
    , id : String
    , opened : Bool
    , title : String
    , titleAttrs : Array (H.Attribute msg)
    , titleCss : Array Style
    , titleHidden : Bool
    , titleHtml : Array (Html msg)
    , windowAttrs : Array (H.Attribute msg)
    , windowCss : Array Style
    , windowHtml : Array (Html msg)
    }


empty : Context msg
empty =
    { backdropAttrs = Array.empty
    , backdropCss = Array.empty
    , id = ""
    , opened = False
    , title = ""
    , titleAttrs = Array.empty
    , titleCss = Array.empty
    , titleHidden = False
    , titleHtml = Array.empty
    , windowAttrs = Array.empty
    , windowCss = Array.empty
    , windowHtml = Array.empty
    }


setId : String -> Context msg -> Context msg
setId id context =
    { context | id = id }


setTitle : String -> Context msg -> Context msg
setTitle title context =
    { context | title = title }


insertAttributes : List (Attribute msg) -> Context msg -> Context msg
insertAttributes attrs ctx =
    List.foldl setAttribute ctx attrs


insertElements : List ( Element, Html msg ) -> Context msg -> Context msg
insertElements elements ctx =
    List.foldl setElement ctx elements


setAttribute : Attribute msg -> Context msg -> Context msg
setAttribute attr ctx =
    case attr of
        Attributes.Batch moreAttrs ->
            List.foldl setAttribute ctx moreAttrs

        Attributes.Css element css ->
            setCss element css ctx

        Attributes.Html element css ->
            setHtmlAttributes element css ctx

        Attributes.Open ->
            { ctx | opened = True }

        Attributes.TitleHidden ->
            { ctx | titleHidden = True }


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Backdrop ->
            { ctx | backdropCss = Array.push css ctx.backdropCss }

        Elements.Title ->
            { ctx | titleCss = Array.push css ctx.titleCss }

        Elements.Window ->
            { ctx | windowCss = Array.push css ctx.windowCss }


setElement : ( Element, Html msg ) -> Context msg -> Context msg
setElement ( element, html ) ctx =
    case element of
        Elements.Backdrop ->
            let
                _ =
                    Debug.log "Warning" "Custom list element is not supported"
            in
                ctx

        Elements.Title ->
            { ctx | titleHtml = Array.push html ctx.titleHtml }

        Elements.Window ->
            { ctx | windowHtml = Array.push html ctx.windowHtml }


setHtmlAttributes : Element -> List (H.Attribute msg) -> Context msg -> Context msg
setHtmlAttributes element attrs ctx =
    case element of
        Elements.Backdrop ->
            { ctx | backdropAttrs = Array.append (Array.fromList attrs) ctx.backdropAttrs }

        Elements.Title ->
            { ctx | titleAttrs = Array.append (Array.fromList attrs) ctx.titleAttrs }

        Elements.Window ->
            { ctx | windowAttrs = Array.append (Array.fromList attrs) ctx.windowAttrs }
