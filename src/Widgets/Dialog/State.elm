module Widgets.Dialog.State
    exposing
        ( Model
        , Msg
        , attributes
        , close
        , disableKeyboardEvents
        , empty
        , enableKeyboardEvents
        , isOpen
        , open
        , subscriptions
        , update
        )

{-| A module to manage the state of a Dialog. It implements the recommended
ARIA behaviour of a Dialog:

  - Forces you to focus an element when opening the dialog.
  - Forces you to provide a first and last focusable elements, so the focus
    cannot go outside of the dialog.
  - Captures `Esc` key pressed to close the dialog.


# State Management (TEA)

@docs Model, Msg, update, subscriptions


# Interacting with the Dialog

@docs empty, open, close, disableKeyboardEvents, enableKeyboardEvents


# Querying the model

@docs isOpen


# Wiring the view

@docs attributes

-}

import Char exposing (KeyCode)
import Dom
import Keyboard
import KeywordList as K
import Task
import Widgets.Dialog.Attributes as Dialog


-- Model --


{-| The model of a Dialog. Create one using `empty` and the `open` if needed.
-}
type Model
    = Model
        { firstId : Dom.Id
        , ignoreKeyboardEvents : Bool
        , lastId : Dom.Id
        , leaveId : Maybe Dom.Id
        , opened : Bool
        }


{-| Creates a empty model that will keep the dialog closed.
-}
empty : Model
empty =
    Model
        { firstId = ""
        , opened = False
        , ignoreKeyboardEvents = False
        , leaveId = Nothing
        , lastId = ""
        }


{-| Return the Dialog Attributes that represent the current state of the
model. Call this function in the view of your application.
-}
attributes : (Msg -> msg) -> Model -> Dialog.Attribute msg
attributes mapMsg (Model { opened }) =
    Dialog.batch <|
        K.fromMany
            [ K.many
                [ Dialog.onFocusLeavesBackward <| mapMsg OnFocusLeavesBackward
                , Dialog.onFocusLeavesForward <| mapMsg OnFocusLeavesForward
                ]
            , K.ifTrue opened Dialog.open
            ]


{-| Opens a dialog, making it visible and disabling other controls (modal). A
pair of node ids should be provided to manage the focus. `enter` should be set
to the id of an element inside the dialog that will get focus after the dialog
is shown. `leave` is optional, and should be set to the id of the element that
trigged the dialog if any.
-}
open :
    { enter : Dom.Id
    , first : Dom.Id
    , last : Dom.Id
    , leave : Maybe Dom.Id
    }
    -> Model
    -> ( Model, Cmd Msg )
open { enter, first, last, leave } (Model model) =
    ( Model
        { model
            | firstId = first
            , lastId = last
            , leaveId = leave
            , opened = True
        }
    , Task.attempt OnFocus (Dom.focus enter)
    )


{-| Closes a dialog. If the dialog was open by user interaction, the focus
should return to the element that trigged the dialog.
-}
close : Model -> ( Model, Cmd Msg )
close (Model model) =
    ( Model { model | opened = False, leaveId = Nothing }
    , model.leaveId
        |> Maybe.map (Dom.focus >> Task.attempt OnFocus)
        |> Maybe.withDefault Cmd.none
    )


{-| Enables the keyboard events handling, enabled by default. When the `Esc` key
is pressed, the dialog will close.
-}
enableKeyboardEvents : Model -> Model
enableKeyboardEvents (Model model) =
    Model { model | ignoreKeyboardEvents = False }


{-| Disables the keyboard events handling. This is useful if you have a editable
control inside the dialog, for example and input. Usually, when people is
editing than control and press `Esc` expect a blur on that control, not the
dialog closing.
-}
disableKeyboardEvents : Model -> Model
disableKeyboardEvents (Model model) =
    Model { model | ignoreKeyboardEvents = True }


{-| Returns true if the model keeps the dialog open.
-}
isOpen : Model -> Bool
isOpen (Model { opened }) =
    opened



-- Update --


{-| A Dialog State message, wire it up into your update using `Cmd.map`.
-}
type Msg
    = OnKeyUp KeyCode
    | OnFocus (Result Dom.Error ())
    | OnFocusLeavesBackward
    | OnFocusLeavesForward


{-| Update a Dialog state given a model and a message. Wire it up into your
update using `Cmd.map`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg ((Model { lastId, firstId }) as model) =
    case msg of
        OnKeyUp 27 ->
            close model

        OnKeyUp keyCode ->
            ( model, Cmd.none )

        OnFocus result ->
            ( model, Cmd.none )

        OnFocusLeavesBackward ->
            ( model, Task.attempt OnFocus (Dom.focus lastId) )

        OnFocusLeavesForward ->
            ( model, Task.attempt OnFocus (Dom.focus firstId) )



-- Subscriptions --


{-| Provides de current subscriptions of the model. Use `Sub.map` to wire it
into your program.
-}
subscriptions : Model -> Sub Msg
subscriptions (Model { opened, ignoreKeyboardEvents }) =
    if opened && not ignoreKeyboardEvents then
        Keyboard.ups OnKeyUp
    else
        Sub.none
