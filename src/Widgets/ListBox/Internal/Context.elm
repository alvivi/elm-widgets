module Widgets.ListBox.Internal.Context
    exposing
        ( Context
        , empty
        , hasDescriptionVisible
        , insertAttributes
        , insertElements
        , selected
        , setDescription
        , setId
        )

import Array exposing (Array)
import Css exposing (Style)
import Html.Styled as H exposing (Html)
import Widgets.Form.Attributes as Form
import Widgets.ListBox.Internal.Attributes as Attributes exposing (Attribute)
import Widgets.ListBox.Internal.Elements as Elements exposing (Element, OptionData)


type alias Context msg =
    { buttonAttrs : Array (Form.Attribute msg)
    , buttonHtml : Array (Html msg)
    , description : String
    , descriptionAttrs : Array (H.Attribute msg)
    , descriptionCss : Array Style
    , descriptionHtml : Array (Html msg)
    , descriptionLabel : Bool
    , expanded : Bool
    , id : String
    , listAttrs : Array (H.Attribute msg)
    , listCss : Array Style
    , options : Array ( OptionData, Html msg )
    , placeholder : Maybe String
    , wrapperAttrs : Array (H.Attribute msg)
    , wrapperCss : Array Style
    }


empty : Context msg
empty =
    { buttonAttrs = Array.empty
    , buttonHtml = Array.empty
    , description = ""
    , descriptionAttrs = Array.empty
    , descriptionCss = Array.empty
    , descriptionHtml = Array.empty
    , descriptionLabel = False
    , expanded = False
    , id = ""
    , listAttrs = Array.empty
    , listCss = Array.empty
    , options = Array.empty
    , placeholder = Nothing
    , wrapperAttrs = Array.empty
    , wrapperCss = Array.empty
    }


setDescription : String -> Context msg -> Context msg
setDescription description context =
    { context | description = description }


setId : String -> Context msg -> Context msg
setId id context =
    { context | id = id }


selected : Context msg -> Maybe OptionData
selected { options } =
    options
        |> Array.filter (Tuple.first >> .selected)
        |> Array.get 0
        |> Maybe.map Tuple.first


hasDescriptionVisible : Context msg -> Bool
hasDescriptionVisible { descriptionLabel, descriptionHtml } =
    descriptionLabel || not (Array.isEmpty descriptionHtml)


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
        Attributes.ButtonAttribute buttonAttr ->
            { ctx | buttonAttrs = Array.push buttonAttr ctx.buttonAttrs }

        Attributes.Css element css ->
            setCss element css ctx

        Attributes.DescriptionLabel ->
            { ctx | descriptionLabel = True }

        Attributes.Expanded ->
            { ctx | expanded = True }

        Attributes.Html element css ->
            setHtmlAttributes element css ctx

        Attributes.Placeholder placeholder ->
            { ctx | placeholder = Just placeholder }


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Button ->
            let
                _ =
                    Debug.log "Warning" "Custom button css is not supported, use buttonAttribute instead"
            in
                ctx

        Elements.Description ->
            { ctx | descriptionCss = Array.push css ctx.descriptionCss }

        Elements.List ->
            { ctx | listCss = Array.push css ctx.listCss }

        Elements.Option _ ->
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

        Elements.Description ->
            { ctx | descriptionHtml = Array.push html ctx.descriptionHtml }

        Elements.List ->
            let
                _ =
                    Debug.log "Warning" "Custom list element is not supported"
            in
                ctx

        Elements.Option data ->
            { ctx | options = Array.push ( data, html ) ctx.options }

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
            let
                _ =
                    Debug.log "Warning" "Custom html attributes are not supported, use buttonAttribute instead"
            in
                ctx

        Elements.Description ->
            { ctx | descriptionAttrs = Array.append (Array.fromList attrs) ctx.descriptionAttrs }

        Elements.List ->
            { ctx | listAttrs = Array.append (Array.fromList attrs) ctx.listAttrs }

        Elements.Option _ ->
            let
                _ =
                    Debug.log "Warning" "Custom HTML attributes are not supported"
            in
                ctx

        Elements.Wrapper ->
            { ctx | wrapperAttrs = Array.append (Array.fromList attrs) ctx.wrapperAttrs }
