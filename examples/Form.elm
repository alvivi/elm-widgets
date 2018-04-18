module Examples.Form exposing (main)

import Css.Foreign as C
import Html
import Html.Styled as H
import Widgets.Normalize as Normalize
import Widgets.Form as Form
import Widgets.Themes.Mint as Theme


main : Html.Html msg
main =
    H.toUnstyled <|
        H.main_ []
            [ C.global Normalize.snippets
            , H.h1 [] [ H.text "Form Examples" ]
            , H.h2 [] [ H.text "Basic" ]
            , Form.input
                { id = "input-basic"
                , description = "A basic input"
                , type_ = "text"
                }
                [ Theme.input ]
                []
            ]
