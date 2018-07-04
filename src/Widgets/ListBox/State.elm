module Widgets.ListBox.State
    exposing
        ( Model
        , Msg
        , attributes
        , empty
        , insertOption
        , isExpanded
        , selected
        , setPlaceholder
        , update
        )

{-| A module to manage the state of a ListBox. It implements the recommended ARIA
behaviour of a ListBox widget.


# State Management (TEA)

@docs Model, Msg, update


# Creating, updating and quering the model

@docs empty, insertOption, isExpanded, selected, setPlaceholder


# Wiring the view

@docs attributes

-}

import Array exposing (Array)
import Char exposing (KeyCode)
import Dom
import Html.Styled.Events as H
import KeywordList as K
import Task
import Widgets.Form.Attributes as Form
import Widgets.Helpers.Array as Array
import Widgets.Helpers.Html.Events as H
import Widgets.ListBox.Attributes as ListBox
import Widgets.ListBox.Elements as ListBox


-- Model --


{-| The model of a ListBox. Create one using empty and insertOption.
-}
type Model
    = Model
        { expanded : Bool
        , focused : Maybe Element
        , id : String
        , options : Array { id : String, text : String }
        , placeholder : Maybe String
        , preventNextEnter : Bool
        , searchText : String
        , selected : Maybe String
        , timeStamp : Int
        }


type Element
    = Button
    | List


{-| Creates a empty model give an element id.
-}
empty : String -> Model
empty id =
    Model
        { expanded = False
        , focused = Nothing
        , id = id
        , options = Array.empty
        , placeholder = Nothing
        , preventNextEnter = False
        , searchText = ""
        , selected = Nothing
        , timeStamp = 0
        }


{-| Return the ListBox Attributes that represent the current state of the
model. Call this function in the view of your application.
-}
attributes : (Msg -> msg) -> Model -> ListBox.Attribute msg
attributes mapMsg (Model model) =
    ListBox.batch <|
        K.fromMany
            [ K.many
                [ ListBox.onOptionClick (OnOptionClick >> mapMsg)
                , ListBox.buttonAttributes
                    [ Form.onBlur <| mapMsg <| OnBlur Button
                    , Form.onClick <| mapMsg OnButtonClick
                    , Form.onFocus <| mapMsg <| OnFocus Button
                    , Form.onKeyUp (OnButtonKeyUp >> mapMsg)
                    ]
                , ListBox.html ListBox.list
                    [ H.onBlur <| mapMsg <| OnBlur List
                    , H.onTimedKeyUp (\timeStamp keyCode -> mapMsg <| OnListTimedKeyUp timeStamp keyCode)
                    ]
                ]
            , K.maybeMap ListBox.placeholder (model.placeholder)
            , K.ifTrue model.expanded ListBox.expanded
            ]


{-| Adds an option to the ListBox. You also need to render the options in your
view. Use selected to known which option is selected.
-}
insertOption : { id : String, text : String } -> Model -> Model
insertOption option (Model model) =
    Model { model | options = Array.push option model.options }


{-| Returns True if the ListBox is currently expanded.
-}
isExpanded : Model -> Bool
isExpanded (Model { expanded }) =
    expanded


{-| Sets a placeholder for the ListBox.
-}
setPlaceholder : String -> Model -> Model
setPlaceholder placeholder (Model model) =
    Model { model | placeholder = Just placeholder }


{-| Returns the current selected option, if any
-}
selected : Model -> Maybe String
selected (Model { options, selected, placeholder }) =
    case selected of
        Nothing ->
            if placeholder == Nothing then
                options
                    |> Array.get 0
                    |> Maybe.map .id
            else
                Nothing

        Just selectedId ->
            Just selectedId



-- Update --


{-| A ListBox State message, wire it up into your update using `Cmd.map`.
-}
type Msg
    = OnBlur Element
    | OnButtonClick
    | OnButtonKeyUp KeyCode
    | OnFocus Element
    | OnListTimedKeyUp Int KeyCode
    | OnOptionClick String


{-| Update a ListBox state given a model and a message. Wire it up into your
update using `Cmd.map`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        OnBlur Button ->
            if model.focused == Just Button then
                ( Model { model | focused = Nothing }, Cmd.none )
            else
                ( Model model, Cmd.none )

        OnBlur List ->
            if model.focused == Just List then
                ( Model { model | focused = Nothing, expanded = False }, Cmd.none )
            else
                ( Model model, Cmd.none )

        OnButtonClick ->
            ( Model { model | expanded = True, preventNextEnter = True }
            , ListBox.list
                |> ListBox.id model.id
                |> Dom.focus
                |> Task.attempt (always <| OnFocus List)
            )

        OnButtonKeyUp 40 ->
            -- Down
            ( Model { model | expanded = True, selected = neighbourId 1 (Model model) }
            , ListBox.list
                |> ListBox.id model.id
                |> Dom.focus
                |> Task.attempt (always <| OnFocus List)
            )

        OnButtonKeyUp 38 ->
            -- Up
            ( Model { model | expanded = True, selected = neighbourId -1 (Model model) }
            , ListBox.list
                |> ListBox.id model.id
                |> Dom.focus
                |> Task.attempt (always <| OnFocus List)
            )

        OnButtonKeyUp _ ->
            ( Model model, Cmd.none )

        OnFocus element ->
            ( Model { model | focused = Just element }, Cmd.none )

        OnListTimedKeyUp _ 13 ->
            -- Enter
            if model.preventNextEnter then
                ( Model { model | preventNextEnter = False }, Cmd.none )
            else
                close (Model model)

        OnListTimedKeyUp _ 27 ->
            -- Escape
            close (Model model)

        OnListTimedKeyUp _ 40 ->
            -- Down
            ( Model { model | selected = neighbourId 1 (Model model) }, Cmd.none )

        OnListTimedKeyUp _ 38 ->
            -- Up
            ( Model { model | selected = neighbourId -1 (Model model) }, Cmd.none )

        OnListTimedKeyUp _ 36 ->
            -- Home
            ( Model
                { model
                    | selected =
                        model.options
                            |> Array.get 0
                            |> Maybe.map .id
                }
            , Cmd.none
            )

        OnListTimedKeyUp _ 35 ->
            -- Home
            ( Model
                { model
                    | selected =
                        model.options
                            |> Array.get (Array.length model.options - 1)
                            |> Maybe.map .id
                }
            , Cmd.none
            )

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
                                | timeStamp = timeStamp
                                , searchText = searchText
                                , selected = Just id
                            }
                        , Cmd.none
                        )

                    Nothing ->
                        ( Model { model | timeStamp = timeStamp, searchText = "" }, Cmd.none )

        OnOptionClick selected ->
            ( Model { model | selected = Just selected }, Cmd.none )


open : Model -> ( Model, Cmd Msg )
open (Model model) =
    ( Model { model | expanded = True }
    , ListBox.list
        |> ListBox.id model.id
        |> Dom.focus
        |> Task.attempt (always <| OnFocus List)
    )


close : Model -> ( Model, Cmd Msg )
close (Model model) =
    ( Model { model | expanded = False }
    , ListBox.button
        |> ListBox.id model.id
        |> Dom.focus
        |> Task.attempt (always <| OnFocus Button)
    )


neighbourId : Int -> Model -> Maybe String
neighbourId diff (Model model) =
    case selected (Model model) of
        Nothing ->
            model.options
                |> Array.get 0
                |> Maybe.map .id

        Just id ->
            model.options
                |> Array.toIndexedList
                |> List.filter (Tuple.second >> .id >> (==) id)
                |> List.head
                |> Maybe.map Tuple.first
                |> Maybe.andThen (\index -> Array.getBounded (index + diff) model.options)
                |> Maybe.map .id


find : String -> Model -> Maybe String
find string (Model { options }) =
    options
        |> Array.filter (.text >> String.toLower >> String.startsWith (String.toLower string))
        |> Array.get 0
        |> Maybe.map .id
