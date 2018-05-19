module Widgets.ListBox.Internal.Elements
    exposing
        ( Element(Button, Description, List, Option, Wrapper)
        , OptionData
        , id
        )


type Element
    = Button
    | Description
    | List
    | Option OptionData
    | Wrapper


type alias OptionData =
    { selected : Bool, text : String, id : String }


id : String -> Element -> String
id base subElement =
    case subElement of
        Button ->
            base ++ "__button"

        Description ->
            base ++ "__desc"

        List ->
            base ++ "__list"

        Option { id } ->
            base ++ "__opt__" ++ id

        Wrapper ->
            base
