module Form exposing (main)

import Css as C
import Css.Foreign as C
import FontAwesome.Regular as FontAwesome
import Html
import Html.Styled as H exposing (Html, fromUnstyled)
import Html.Styled.Attributes as H
import Widgets.Form as Form
import Widgets.Form.Attributes as Form
import Widgets.Form.Elements as Form
import Widgets.Normalize as Normalize
import Widgets.Themes.Mint as Theme


-- View


view : Model -> Html Msg
view model =
    H.main_ []
        [ C.global Normalize.snippets
        , Theme.global
        , H.main_
            [ H.css
                [ C.margin2 C.zero C.auto
                , C.maxWidth <| C.px 1200
                ]
            ]
            [ H.h1 [] [ H.text "Form Examples" ]
            , table
                [ ( "Basic"
                  , Form.input
                        { id = "input-basic"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        []
                        []
                  , Form.input
                        { id = "themed-input-basic"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Placeholder"
                  , Form.input
                        { id = "input-placeholder"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Form.placeholder "placeholder" ]
                        []
                  , Form.input
                        { id = "themed-input-placeholder"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Theme.input
                        , Form.placeholder "placeholder"
                        ]
                        []
                  )
                , ( "Labeled"
                  , Form.input
                        { id = "input-labeled"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Form.descriptionLabel
                        , focused "input-labeled" model
                        , Form.onBlur <| OnBlur "input-labeled"
                        , Form.onFocus <| OnFocus "input-labeled"
                        ]
                        []
                  , Form.input
                        { id = "themed-input-labeled"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Theme.input
                        , Form.descriptionLabel
                        , focused "themed-input-labeled" model
                        , Form.onBlur <| OnBlur "themed-input-labeled"
                        , Form.onFocus <| OnFocus "themed-input-labeled"
                        ]
                        []
                  )
                , ( "Labeled with a custom description"
                  , Form.input
                        { id = "input-labeled"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Form.descriptionLabel
                        , focused "input-labeled-custom" model
                        , Form.onBlur <| OnBlur "input-labeled-custom"
                        , Form.onFocus <| OnFocus "input-labeled-custom"
                        ]
                        [ ( Form.Description
                          , H.span []
                                [ H.text "A "
                                , H.strong [ H.css [ C.color <| C.hex "#0000CC" ] ] [ H.text "not " ]
                                , H.text "so basic input "
                                ]
                          )
                        ]
                  , Form.input
                        { id = "themed-input-labeled-custom"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Theme.input
                        , Form.descriptionLabel
                        , focused "themed-input-labeled-custom" model
                        , Form.onBlur <| OnBlur "themed-input-labeled-custom"
                        , Form.onFocus <| OnFocus "themed-input-labeled-custom"
                        ]
                        [ ( Form.Description
                          , H.span [ H.css [ Theme.text ] ]
                                [ H.text "A "
                                , H.strong [ H.css [ C.color <| C.hex "#0000CC" ] ] [ H.text "not " ]
                                , H.text "so basic input "
                                ]
                          )
                        ]
                  )
                , ( "Disabled"
                  , Form.input
                        { id = "input-disabled"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Form.disabled ]
                        []
                  , Form.input
                        { id = "themed-input-disabled"
                        , description = "A basic input"
                        , type_ = "text"
                        }
                        [ Theme.input
                        , Form.disabled
                        ]
                        []
                  )
                , ( "With an Icon"
                  , Form.email
                        { id = "input-icon"
                        , description = "A basic input"
                        }
                        []
                        [ ( Form.Icon, fromUnstyled <| FontAwesome.envelope ) ]
                  , Form.email
                        { id = "themed-input-disabled"
                        , description = "A basic input"
                        }
                        [ Theme.input ]
                        [ ( Form.Icon, fromUnstyled <| FontAwesome.envelope ) ]
                  )
                , ( "Semantic - Current Password"
                  , Form.currentPassword
                        { id = "input-current-password"
                        , description = "current password"
                        }
                        []
                        []
                  , Form.currentPassword
                        { id = "themed-input-current-password"
                        , description = "current password"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - Email"
                  , Form.email
                        { id = "input-email"
                        , description = "email"
                        }
                        []
                        []
                  , Form.email
                        { id = "themed-input-email"
                        , description = "email"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - First Name"
                  , Form.firstName
                        { id = "input-first-name"
                        , description = "first name"
                        }
                        []
                        []
                  , Form.firstName
                        { id = "themed-input-first-name"
                        , description = "first name"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - Last Name"
                  , Form.lastName
                        { id = "input-last-name"
                        , description = "last name"
                        }
                        []
                        []
                  , Form.lastName
                        { id = "themed-input-last-name"
                        , description = "last name"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - New Password"
                  , Form.newPassword
                        { id = "input-new-password"
                        , description = "new password"
                        }
                        []
                        []
                  , Form.newPassword
                        { id = "themed-input-new-password"
                        , description = "new password"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - Nickname"
                  , Form.nickname
                        { id = "input-nickname"
                        , description = "nickname"
                        }
                        []
                        []
                  , Form.nickname
                        { id = "themed-input-nickname"
                        , description = "nickname"
                        }
                        [ Theme.input ]
                        []
                  )
                , ( "Semantic - Organization"
                  , Form.organization
                        { id = "input-organization"
                        , description = "organization"
                        }
                        []
                        []
                  , Form.organization
                        { id = "themed-input-organization"
                        , description = "organization"
                        }
                        [ Theme.input ]
                        []
                  )
                ]
            ]
        ]


focused : String -> Model -> Form.Attribute msg
focused id { focused } =
    if id == focused then
        Form.focused
    else
        Form.batch []



--table : List ( String, Html msg, Html msg ) -> Html msg
--table rows =
--let
--cellStyle =
--C.batch
--[ C.borderBottom3 (C.px 1) C.solid (C.hex "#CCC")
--, C.displayFlex
--, C.alignItems C.center
--, C.justifyContent C.center
--]
--in
--H.table [ H.css [ C.width <| C.pct 100 ] ]
--(H.tr
--[ H.css
--[ C.width <| C.pct 100
--]
--]
--[ H.th [ H.css [ cellStyle ] ] [ H.text "" ]
--, H.th [ H.css [ cellStyle ] ] [ H.text "Unstyled" ]
--, H.th [ H.css [ cellStyle ] ] [ H.text "Mint Theme" ]
--]
--:: List.map
--(\( title, unstyledHtml, styledHtml ) ->
--H.tr
--[ H.css
--[ C.width <| C.pct 100
--]
--]
--[ H.td [ H.css [ cellStyle ] ] [ H.text title ]
--, H.td [ H.css [ cellStyle ] ] [ unstyledHtml ]
--, H.td [ H.css [ cellStyle ] ] [ styledHtml ]
--]
--)
--rows
--)


table : List ( String, Html msg, Html msg ) -> Html msg
table list =
    let
        cell width content =
            H.div
                [ H.css
                    [ C.alignItems C.center
                    , C.displayFlex
                    , C.flexDirection C.column
                    , C.flexGrow <| C.int 1
                    , C.justifyContent C.center
                    , C.width <| C.pct width
                    , C.minHeight <| C.px 80
                    ]
                ]
                [ content ]
    in
    H.div
        [ H.css
            [ C.width <| C.pct 100
            , C.displayFlex
            , C.flexWrap C.wrap
            ]
        ]
    <|
        List.concatMap
            (\( title, lhs, rhs ) ->
                [ cell 20 (H.text title), cell 40 lhs, cell 40 rhs ]
            )
            list



-- Model


type alias Model =
    { focused : String
    }


empty : Model
empty =
    { focused = "" }



-- Update


type Msg
    = OnBlur String
    | OnFocus String


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnBlur id ->
            if model.focused == id then
                { model | focused = "" }
            else
                model

        OnFocus id ->
            { model | focused = id }



-- Main


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = empty
        , view = view >> H.toUnstyled
        , update = update
        }
