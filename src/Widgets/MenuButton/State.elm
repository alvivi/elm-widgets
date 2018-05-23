module Widgets.MenuButton.State
    exposing
        ( Model
        , Msg
        , attributes
        , empty
        , focused
        , insertMenuItem
        , update
        )

{-| A module to manage the state of a MenuButton. Very similar to
ListBox.State. The main difference between both is that MenuButton is based
on over event.

Can be also used on a ListBox instead of a MenuButton.


# State Management (TEA)

@docs Model, Msg, update


# Creating, updating and quering the model

@docs empty, insertMenuItem, focused


# Wiring the view

@docs attributes

-}

import Array exposing (Array)
import Char exposing (KeyCode)
import Dom
import Html.Styled.Events as H
import Json.Decode as JD
import KeywordList as K
import Task
import Widgets.Form.Attributes as Form
import Widgets.Helpers.Array as Array
import Widgets.Helpers.Html.Events as H
import Widgets.ListBox.Attributes as ListBox
import Widgets.ListBox.Elements as ListBox


{-| The model of a MenuButton. Create one using empty and insertOption.
-}
type Model
    = Model
        { expanded : Bool
        , focused : Maybe String
        , id : String
        , menuItems : Array { id : String, text : String }
        , searchText : String
        , timeStamp : Int
        }


{-| Creates an empty MenuButton model given an id.
-}
empty : String -> Model
empty id =
    Model
        { expanded = False
        , focused = Nothing
        , id = id
        , menuItems = Array.empty
        , searchText = ""
        , timeStamp = 0
        }


{-| Return the MenuButton a ttributes that represent the current state of the
model. Call this function in the view of your application.
-}
attributes : (Msg -> msg) -> Model -> ListBox.Attribute msg
attributes mapMsg (Model model) =
    ListBox.batch <|
        K.fromMany
            [ K.many
                [ ListBox.buttonAttributes
                    [ Form.onKeyUp (OnButtonKeyUp >> mapMsg)
                    ]
                , ListBox.html ListBox.wrapper
                    [ H.onMouseEnter <| mapMsg OnWrapperMouseEnter
                    , H.onMouseLeave <| mapMsg OnWrapperMouseLeave
                    ]
                , ListBox.html ListBox.list
                    [ H.onBlur <| mapMsg OnListBlur
                    , H.onTimedKeyUp (\timeStamp keyCode -> mapMsg <| OnListTimedKeyUp timeStamp keyCode)
                    ]
                , ListBox.html ListBox.anyOption
                    [ H.on "mouseenter"
                        (JD.map (\id -> mapMsg <| OnMenuItemMouseEnter id)
                            (JD.at [ "target", "id" ] JD.string)
                        )
                    ]
                ]
            , K.ifTrue (model.expanded) ListBox.expanded
            ]


{-| Adds an option to the ListBox. You also need to render the options in your
view. Use selected to known which option is selected.
-}
insertMenuItem : { id : String, text : String } -> Model -> Model
insertMenuItem option (Model model) =
    Model { model | menuItems = Array.push option model.menuItems }


{-| Returns the current focused option, if any
-}
focused : Model -> Maybe String
focused (Model model) =
    model.focused


{-| A MenuButton State message, wire it up into your update using `Cmd.map`.
-}
type Msg
    = OnButtonFocus
    | OnButtonKeyUp KeyCode
    | OnListBlur
    | OnListFocus
    | OnListTimedKeyUp Int KeyCode
    | OnMenuItemMouseEnter String
    | OnWrapperMouseEnter
    | OnWrapperMouseLeave


{-| Update a MenuButton state given a model and a message. Wire it up into your
update using `Cmd.map`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        OnButtonFocus ->
            ( Model model, Cmd.none )

        OnButtonKeyUp 13 ->
            -- Enter
            open (Maybe.map .id <| Array.first model.menuItems) (Model model)

        OnButtonKeyUp 32 ->
            -- Space
            open (Maybe.map .id <| Array.first model.menuItems) (Model model)

        OnButtonKeyUp 38 ->
            -- Up
            open (Maybe.map .id <| Array.last model.menuItems) (Model model)

        OnButtonKeyUp 40 ->
            -- Down
            open (Maybe.map .id <| Array.first model.menuItems) (Model model)

        OnButtonKeyUp _ ->
            ( Model { model | expanded = False }, Cmd.none )

        OnListTimedKeyUp _ 27 ->
            -- Esc
            close { resetFocus = True } (Model model)

        OnListTimedKeyUp _ 35 ->
            -- End
            ( Model { model | focused = Maybe.map .id <| Array.last model.menuItems }, Cmd.none )

        OnListTimedKeyUp _ 36 ->
            -- Home
            ( Model { model | focused = Maybe.map .id <| Array.first model.menuItems }, Cmd.none )

        OnListTimedKeyUp _ 38 ->
            -- Down
            ( Model { model | focused = neighbourId -1 (Model model) }, Cmd.none )

        OnListTimedKeyUp _ 40 ->
            -- Down
            ( Model { model | focused = neighbourId 1 (Model model) }, Cmd.none )

        OnListTimedKeyUp timeStamp keyCode ->
            -- Search by text
            let
                prevSearchText =
                    if timeStamp - model.timeStamp > 500 then
                        ""
                    else
                        model.searchText

                searchText =
                    prevSearchText ++ String.fromChar (Char.fromCode keyCode)
            in
                case find searchText (Model model) of
                    Just id ->
                        ( Model
                            { model
                                | focused = Just id
                                , searchText = searchText
                                , timeStamp = timeStamp
                            }
                        , Cmd.none
                        )

                    Nothing ->
                        ( Model { model | timeStamp = timeStamp, searchText = "" }, Cmd.none )

        OnListBlur ->
            close { resetFocus = False } (Model model)

        OnListFocus ->
            ( Model model, Cmd.none )

        OnMenuItemMouseEnter id ->
            ( Model { model | focused = Just id }, Cmd.none )

        OnWrapperMouseEnter ->
            open Nothing (Model model)

        OnWrapperMouseLeave ->
            ( (Model { model | expanded = False }), Cmd.none )


open : Maybe String -> Model -> ( Model, Cmd Msg )
open requestFocus (Model model) =
    let
        focused =
            case ( requestFocus, model.focused ) of
                ( Nothing, Nothing ) ->
                    model.menuItems
                        |> Array.get 0
                        |> Maybe.map .id

                ( Nothing, Just id ) ->
                    Just id

                ( Just id, _ ) ->
                    Just id
    in
        ( (Model { model | expanded = True, focused = focused })
        , ListBox.list
            |> ListBox.id model.id
            |> Dom.focus
            |> Task.attempt (always <| OnListFocus)
        )


close : { resetFocus : Bool } -> Model -> ( Model, Cmd Msg )
close { resetFocus } (Model model) =
    let
        cmd =
            if resetFocus then
                ListBox.button
                    |> ListBox.id model.id
                    |> Dom.focus
                    |> Task.attempt (always <| OnButtonFocus)
            else
                Cmd.none
    in
        ( Model { model | expanded = False }, cmd )


neighbourId : Int -> Model -> Maybe String
neighbourId diff (Model model) =
    case focused (Model model) of
        Nothing ->
            model.menuItems
                |> Array.get 0
                |> Maybe.map .id

        Just id ->
            model.menuItems
                |> Array.toIndexedList
                |> List.filter (Tuple.second >> .id >> (==) id)
                |> List.head
                |> Maybe.map Tuple.first
                |> Maybe.andThen (\index -> Array.getCycling (index + diff) model.menuItems)
                |> Maybe.map .id


find : String -> Model -> Maybe String
find string (Model { menuItems }) =
    menuItems
        |> Array.filter (.text >> String.toLower >> String.startsWith (String.toLower string))
        |> Array.get 0
        |> Maybe.map .id
