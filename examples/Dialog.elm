module Dialog exposing (main)

import Html.Styled as H exposing (Html)
import KeywordList as K
import Widgets.Dialog as Widgets
import Widgets.Dialog.Attributes as Dialog
import Widgets.Dialog.Elements as Dialog
import Widgets.Form as Widgets
import Widgets.Form.Attributes as Form


-- View --


view : Model -> Html Msg
view model =
    H.div []
        [ Widgets.button
            [ Form.onClick OnOpenUnstyled
            ]
            [ H.text "Open Unstyled Dialog"
            ]
        , Widgets.dialog { id = "dialog-unstyuled", title = "A simple dialog" }
            (K.fromMany
                [ K.ifTrue model.unstyledOpen Dialog.open
                ]
            )
            [ ( Dialog.window
              , Widgets.button
                    [ Form.onClick OnCloseUnstyled ]
                    [ H.text "Close" ]
              )
            ]
        ]



-- Model --


type alias Model =
    { unstyledOpen : Bool
    }


empty : Model
empty =
    { unstyledOpen = False
    }



-- Update --


type Msg
    = OnCloseUnstyled
    | OnOpenUnstyled


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCloseUnstyled ->
            ( { model | unstyledOpen = False }, Cmd.none )

        OnOpenUnstyled ->
            ( { model | unstyledOpen = True }, Cmd.none )



-- Initialization --


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
