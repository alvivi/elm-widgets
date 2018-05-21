module Widgets.ListBox.Internal.Elements
    exposing
        ( Element(Button, Description, List, Option, Wrapper)
        , OptionData
        )


type Element
    = Button
    | Description
    | List
    | Option OptionData
    | Wrapper


type alias OptionData =
    { selected : Bool, text : String, id : String }
