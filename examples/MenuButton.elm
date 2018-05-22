module MenuButton exposing (main)

import Css as C
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import KeywordList as K
import Widgets.ListBox.Elements as ListBox
import Widgets.MenuButton as Widgets


-- View --


view : Model -> Html Msg
view model =
    Widgets.menuButton { id = "menubutton", description = "a menu" }
        []
        (List.map
            (\{ id, text } ->
                ( ListBox.option
                    { selected = False
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

                            --, K.ifTrue isSelected <| C.backgroundColor Color.blue
                            ]
                    ]
                    [ H.text text ]
                )
            )
            options
        )



-- Model --


type alias Model =
    {}


empty : Model
empty =
    {}



-- Update --


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- Initialization --


options : List { id : String, text : String }
options =
    [ { text = "link one", id = "1" }
    , { text = "link two", id = "2" }
    , { text = "link three", id = "3" }
    , { text = "link over 9000", id = "9001" }
    ]


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
