module ListBox exposing (main)

import Css as C
import Css.Colors as Color
import FontAwesome.Regular as FontAwesome
import Html.Styled as H exposing (Html, fromUnstyled)
import Html.Styled.Attributes as H
import KeywordList as K
import Widgets.ListBox as Widgets
import Widgets.ListBox.Elements as ListBox
import Widgets.ListBox.State as ListBox
import Widgets.Themes.Mint as Theme


-- View --


view : Model -> Html Msg
view model =
    H.div []
        [ Widgets.listBox { id = "unstyled", description = "A unstyled listbox example" }
            [ ListBox.attributes UnstyledListBoxMsg model.unstyled ]
            (( ListBox.icon, fromUnstyled <| FontAwesome.caret_square_down )
                :: List.map
                    (\{ id, text } ->
                        let
                            isSelected =
                                ListBox.selected model.unstyled == Just id
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
                    unstyledOptions
            )
        , Widgets.listBox { id = "styled", description = "A styled listbox example" }
            [ ListBox.attributes StyledListBoxMsg model.styled
            , Theme.listBox
            ]
            (( ListBox.icon, fromUnstyled <| FontAwesome.caret_square_down )
                :: List.map
                    (\{ id, text } ->
                        let
                            isSelected =
                                ListBox.selected model.styled == Just id
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
                    styledOptions
            )
        ]



-- Model --


type alias Model =
    { unstyled : ListBox.Model
    , styled : ListBox.Model
    }


empty : Model
empty =
    { unstyled =
        List.foldl ListBox.insertOption (ListBox.empty "unstyled") unstyledOptions
    , styled =
        List.foldl ListBox.insertOption (ListBox.empty "styled") styledOptions
    }



-- Update --


type Msg
    = StyledListBoxMsg ListBox.Msg
    | UnstyledListBoxMsg ListBox.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StyledListBoxMsg subMsg ->
            let
                ( styled, cmd ) =
                    ListBox.update subMsg model.styled
            in
                ( { model | styled = styled }, Cmd.map StyledListBoxMsg cmd )

        UnstyledListBoxMsg subMsg ->
            let
                ( unstyled, cmd ) =
                    ListBox.update subMsg model.unstyled
            in
                ( { model | unstyled = unstyled }, Cmd.map UnstyledListBoxMsg cmd )



-- Initialization --


unstyledOptions : List { id : String, text : String }
unstyledOptions =
    [ { text = "One", id = "1" }
    , { text = "Two", id = "2" }
    , { text = "Three", id = "3" }
    , { text = "Over 9000", id = "9001" }
    ]


styledOptions : List { id : String, text : String }
styledOptions =
    [ { text = "Wow", id = "wow" }
    , { text = "Many options", id = "edits" }
    , { text = "Very readable", id = "readable" }
    , { text = "To the moon", id = "moon" }
    ]


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
