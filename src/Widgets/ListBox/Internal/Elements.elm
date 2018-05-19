module Widgets.ListBox.Internal.Elements
    exposing
        ( Element(Button, Description, List, Option, Wrapper)
        , id
        )


type Element
    = Button
    | Description
    | List
    | Option
    | Wrapper


id : String -> Element -> String
id base subElement =
    case subElement of
        Button ->
            base ++ "__button"

        Description ->
            base ++ "__desc"

        List ->
            base ++ "__list"

        Option ->
            ""

        Wrapper ->
            base
