module Widgets.ListBox.Internal.Elements
    exposing
        ( Element(Button, List, Option, Wrapper)
        , id
        )


type Element
    = Button
    | List
    | Option
    | Wrapper


id : String -> Element -> String
id base subElement =
    case subElement of
        Button ->
            base ++ "__button"

        List ->
            base ++ "__list"

        Option ->
            ""

        Wrapper ->
            base
