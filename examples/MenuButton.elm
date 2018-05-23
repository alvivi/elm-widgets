module MenuButton exposing (main)

import Css as C
import Css.Colors as Color
import Html.Styled as H exposing (Html)
import Html.Styled.Attributes as H
import KeywordList as K
import Widgets.ListBox.Elements as ListBox
import Widgets.MenuButton as Widgets
import Widgets.MenuButton.Elements as MenuButton
import Widgets.MenuButton.State as MenuButton


-- View --


view : Model -> Html Msg
view model =
    Widgets.menuButton { id = "menubutton", description = "a menu" }
        [ MenuButton.attributes MenuButtonMsg model.menuButton ]
        (List.map
            (\({ id, text, href } as linkData) ->
                let
                    isFocused =
                        MenuButton.focused model.menuButton == Just id
                in
                    MenuButton.menuLink linkData
                        [ H.css <|
                            K.fromMany
                                [ K.many
                                    [ C.display C.inlineBlock
                                    , C.width <| C.pct 100
                                    ]
                                , K.ifTrue isFocused <| C.backgroundColor Color.blue
                                ]
                        ]
            )
            options
        )



-- Model --


type alias Model =
    { menuButton : MenuButton.Model }


empty : Model
empty =
    { menuButton =
        List.foldl
            (\{ id, text } ->
                MenuButton.insertMenuItem { id = id, text = text }
            )
            (MenuButton.empty "menubutton")
            options
    }



-- Update --


type Msg
    = MenuButtonMsg MenuButton.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MenuButtonMsg subMsg ->
            let
                ( menuButton, cmd ) =
                    MenuButton.update subMsg model.menuButton
            in
                ( { model | menuButton = menuButton }, Cmd.map MenuButtonMsg cmd )



-- Initialization --


options : List { id : String, text : String, href : String }
options =
    [ { id = "wai-wai"
      , text = "W3C Web Accessibility Initiative"
      , href = "https://www.w3.org/standards/webdesign/accessibility"
      }
    , { id = "wai-rias"
      , href = "https://www.w3.org/TR/wai-aria/"
      , text = "Accessible Rich Internet Application Specification"
      }
    , { id = "wai-wap"
      , href = "https://www.w3.org/TR/wai-aria-practices/"
      , text = "WAI-ARIA Authoring Practices"
      }
    , { id = "wai-waim"
      , href = "https://www.w3.org/TR/wai-aria-implementation/"
      , text = "WAI-ARIA Implementation Guide"
      }
    , { id = "wai-aam"
      , href = "https://www.w3.org/TR/accname-aam-1.1/"
      , text = "Accessible Name and Description"
      }
    ]


main : Program Never Model Msg
main =
    H.program
        { init = ( empty, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
