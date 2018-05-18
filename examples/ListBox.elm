module ListBox exposing (main)

import Html.Styled as H exposing (Html)
import Widgets.ListBox as Widgets
import Widgets.ListBox.Elements as ListBox


-- View --


view : Model -> Html msg
view model =
    Widgets.listBox { id = "listbox" }
        [ ListBox.textOption "one"
        , ListBox.textOption "two"
        , ListBox.textOption "three"
        , ListBox.textOption "over 9000"
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
