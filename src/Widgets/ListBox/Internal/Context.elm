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
import Widgets.Form.Elements as Form
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
    , iconAttrs : Array (H.Attribute msg)
    , iconCss : Array Style
    , iconHtml : Array (Html msg)
    , id : String
    , listAttrs : Array (H.Attribute msg)
    , listCss : Array Style
    , onOptionClick : Maybe (String -> msg)
    , options : Array ( OptionData, Html msg )
    , optionsAttrs : Array (H.Attribute msg)
    , optionsCss : Array Style
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
    , iconAttrs = Array.empty
    , iconCss = Array.empty
    , iconHtml = Array.empty
    , id = ""
    , listAttrs = Array.empty
    , listCss = Array.empty
    , onOptionClick = Nothing
    , options = Array.empty
    , optionsAttrs = Array.empty
    , optionsCss = Array.empty
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
    attrs
        |> List.foldl setAttribute ctx
        |> (\ctx_ -> List.foldl setAttributeModifiers ctx_ attrs)


insertElements : List ( Element, Html msg ) -> Context msg -> Context msg
insertElements elements ctx =
    List.foldl setElement ctx elements


setAttribute : Attribute msg -> Context msg -> Context msg
setAttribute attr ctx =
    case attr of
        Attributes.Batch moreAttrs ->
            List.foldl setAttribute ctx moreAttrs

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

        Attributes.OnOptionClick handler ->
            { ctx | onOptionClick = Just handler }

        Attributes.Placeholder placeholder ->
            { ctx | placeholder = Just placeholder }

        Attributes.WhenExpanded _ ->
            ctx

        Attributes.WhenHasIcon _ ->
            ctx


setAttributeModifiers : Attribute msg -> Context msg -> Context msg
setAttributeModifiers attr ctx =
    case attr of
        Attributes.WhenExpanded expandedAttrs ->
            if ctx.expanded then
                insertAttributes expandedAttrs ctx
            else
                ctx

        Attributes.WhenHasIcon iconAttrs ->
            if Array.isEmpty ctx.iconHtml then
                ctx
            else
                insertAttributes iconAttrs ctx

        _ ->
            ctx


setCss : Element -> Style -> Context msg -> Context msg
setCss element css ctx =
    case element of
        Elements.Button ->
            { ctx | buttonAttrs = Array.push (Form.css Form.control [ css ]) ctx.buttonAttrs }

        Elements.Description ->
            { ctx | descriptionCss = Array.push css ctx.descriptionCss }

        Elements.Icon ->
            { ctx | iconCss = Array.push css ctx.iconCss }

        Elements.List ->
            { ctx | listCss = Array.push css ctx.listCss }

        Elements.Option _ ->
            { ctx | optionsCss = Array.push css ctx.optionsCss }

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

        Elements.Icon ->
            { ctx | iconHtml = Array.push html ctx.iconHtml }

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
            { ctx | buttonAttrs = Array.push (Form.html Form.control attrs) ctx.buttonAttrs }

        Elements.Description ->
            { ctx | descriptionAttrs = Array.append (Array.fromList attrs) ctx.descriptionAttrs }

        Elements.Icon ->
            { ctx | iconAttrs = Array.append (Array.fromList attrs) ctx.iconAttrs }

        Elements.List ->
            { ctx | listAttrs = Array.append (Array.fromList attrs) ctx.listAttrs }

        Elements.Option _ ->
            { ctx | optionsAttrs = Array.append (Array.fromList attrs) ctx.optionsAttrs }

        Elements.Wrapper ->
            { ctx | wrapperAttrs = Array.append (Array.fromList attrs) ctx.wrapperAttrs }
