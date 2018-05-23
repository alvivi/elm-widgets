module ListBox exposing (main)

import Css as C
import Css.Colors as Color
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import KeywordList as K
import Widgets.ListBox as Widgets
import Widgets.ListBox.Elements as ListBox
import Widgets.ListBox.State as ListBox


-- View --


view : Model -> Html Msg
view model =
    Widgets.listBox { id = "listbox", description = "A listbox example" }
        [ ListBox.attributes ListBoxMsg model.listBox ]
        (List.map
            (\{ id, text } ->
                let
                    isSelected =
                        ListBox.selected model.listBox == Just id
                in
                    ( ListBox.option
                        { selected = isSelected
                        , text = text
                        , id = id
                        }
                    , H.span
                        [ H.css <|
                            K.fromMany
                                [ K.many
                                    [ C.display C.inlineBlock
                                    , C.width <| C.pct 100
                                    ]
                                , K.ifTrue isSelected <| C.backgroundColor Color.blue
                                ]
                        ]
                        [ H.text text ]
                    )
            )
            options
        )



-- Model --


type alias Model =
    { listBox : ListBox.Model }


empty : Model
empty =
    { listBox =
        List.foldl ListBox.insertOption (ListBox.empty "listbox") options
    }



-- Update --


type Msg
    = ListBoxMsg ListBox.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ListBoxMsg subMsg ->
            let
                ( listBox, cmd ) =
                    ListBox.update subMsg model.listBox
            in
                ( { model | listBox = listBox }, Cmd.map ListBoxMsg cmd )



-- Initialization --


options : List { id : String, text : String }
options =
    [ { text = "one", id = "1" }
    , { text = "two", id = "2" }
    , { text = "three", id = "3" }
    , { text = "over 9000", id = "9001" }
    ]


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
