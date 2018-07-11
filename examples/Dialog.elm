module Dialog exposing (main)

import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import Widgets.Dialog as Widgets
import Widgets.Dialog.Elements as Dialog
import Widgets.Dialog.State as DialogState
import Widgets.Form as Widgets
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form
import Widgets.Themes.Mint as Theme


-- View --


view : Model -> Html Msg
view model =
    H.div []
        [ Widgets.button
            [ Form.onClick OnOpenUnstyled
            , Form.html Form.control [ H.id "unstyled-button-open" ]
            ]
            [ H.text "Open Unstyled Dialog"
            ]
        , Widgets.button
            [ Form.onClick OnOpenStyled
            , Form.html Form.control [ H.id "styled-button-open" ]
            ]
            [ H.text "Open Styled Dialog"
            ]
        , Widgets.dialog { id = "dialog-unstyuled", title = "A simple dialog" }
            [ DialogState.attributes UnstyledDialogMsg model.unstyledState ]
            [ ( Dialog.window
              , Widgets.button
                    [ Form.onClick OnCloseUnstyled
                    , Form.html Form.control [ H.id "unstyled-button-close" ]
                    ]
                    [ H.text "Close" ]
              )
            ]
        , Widgets.dialog { id = "dialog-styled", title = "An styled dialog" }
            [ Theme.dialog
            , DialogState.attributes StyledDialogMsg model.styledState
            ]
            [ ( Dialog.window
              , Widgets.button
                    [ Theme.button
                    , Form.onClick OnCloseStyled
                    , Form.html Form.control [ H.id "styled-button-close" ]
                    ]
                    [ H.text "Close" ]
              )
            ]
        ]



-- Model --


type alias Model =
    { unstyledState : DialogState.Model
    , styledState : DialogState.Model
    }


empty : Model
empty =
    { unstyledState = DialogState.empty
    , styledState = DialogState.empty
    }



-- Update --


type Msg
    = OnCloseStyled
    | OnCloseUnstyled
    | OnOpenStyled
    | OnOpenUnstyled
    | UnstyledDialogMsg DialogState.Msg
    | StyledDialogMsg DialogState.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCloseStyled ->
            let
                ( nextState, nextMsg ) =
                    DialogState.close model.styledState
            in
                ( { model | styledState = nextState }, Cmd.map StyledDialogMsg nextMsg )

        OnCloseUnstyled ->
            let
                ( nextState, nextMsg ) =
                    DialogState.close model.unstyledState
            in
                ( { model | unstyledState = nextState }, Cmd.map UnstyledDialogMsg nextMsg )

        OnOpenStyled ->
            let
                ( nextState, nextMsg ) =
                    DialogState.open
                        { enter = "styled-button-close"
                        , first = "styled-button-close"
                        , last = "styled-button-close"
                        , leave = Just "styled-button-open"
                        }
                        model.styledState
            in
                ( { model | styledState = nextState }, Cmd.map StyledDialogMsg nextMsg )

        OnOpenUnstyled ->
            let
                ( nextState, nextMsg ) =
                    DialogState.open
                        { enter = "unstyled-button-close"
                        , first = "unstyled-button-close"
                        , last = "unstyled-button-close"
                        , leave = Just "unstyled-button-open"
                        }
                        model.unstyledState
            in
                ( { model | unstyledState = nextState }, Cmd.map UnstyledDialogMsg nextMsg )

        UnstyledDialogMsg dialogMsg ->
            let
                ( nextState, nextMsg ) =
                    DialogState.update dialogMsg model.unstyledState
            in
                ( { model | unstyledState = nextState }
                , Cmd.map UnstyledDialogMsg nextMsg
                )

        StyledDialogMsg dialogMsg ->
            let
                ( nextState, nextMsg ) =
                    DialogState.update dialogMsg model.styledState
            in
                ( { model | styledState = nextState }
                , Cmd.map StyledDialogMsg nextMsg
                )



-- Initialization --


subscriptions : Model -> Sub Msg
subscriptions { styledState, unstyledState } =
    Sub.batch
        [ Sub.map StyledDialogMsg <| DialogState.subscriptions styledState
        , Sub.map UnstyledDialogMsg <| DialogState.subscriptions unstyledState
        ]


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
