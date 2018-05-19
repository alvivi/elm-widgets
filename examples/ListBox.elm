module ListBox exposing (main)

import Html.Styled as H exposing (Html)
import Widgets.ListBox as Widgets
import Widgets.ListBox.Elements as ListBox


-- View --


view : Model -> Html msg
view model =
    Widgets.listBox { id = "listbox", description = "A listbox example" }
        []
        [ ListBox.textOption { selected = False, text = "one", id = "1" }
        , ListBox.textOption { selected = False, text = "two", id = "2" }
        , ListBox.textOption { selected = False, text = "three", id = "3" }
        , ListBox.textOption { selected = False, text = "over 9000", id = "9001" }
        ]



-- Model --


type alias Model =
    {}


empty : Model
empty =
    {}



-- Update --


type Msg
    = Noop


update : Msg -> Model -> Model
update msg model =
    model



-- Initialization --


main : Program Never Model Msg
main =
    H.beginnerProgram
        { model = empty
        , view = view
        , update = update
        }
