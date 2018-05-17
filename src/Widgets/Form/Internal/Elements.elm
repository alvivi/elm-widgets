module Widgets.Form.Internal.Elements
    exposing
        ( Element
            ( Control
            , Description
            , Error
            , Icon
            , Label
            )
        , id
        )


type Element
    = Control
    | Description
    | Error
    | Icon
    | Label


id : String -> Element -> String
id base subElement =
    case subElement of
        Control ->
            base

        Description ->
            base ++ "__description"

        Error ->
            base ++ "__error"

        Icon ->
            base ++ "__icon"

        Label ->
            base ++ "__label"
